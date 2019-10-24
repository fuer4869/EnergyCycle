//
//  ETLoginVC.m
//  能量圈
//
//  Created by 王斌 on 2017/4/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLoginVC.h"
#import "ETLoginViewModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import "ETNavigationController.h"
#import "ETWebVC.h"

#import "ShareSDKManager.h"

@interface ETLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqButton;

@property (nonatomic, strong) ETLoginViewModel *viewModel;

@end

@implementation ETLoginVC

- (ETLoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETLoginViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBtn.backgroundColor = [UIColor jk_colorWithHexString:@"E05954"];
    
    [self setupTextFieldPlaceholder];
    
//    self.qqButton.hidden = ![ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupTextFieldPlaceholder {
    self.phoneNumberTextField.attributedPlaceholder = [self changePlaceholderColor:self.phoneNumberTextField];
    self.verificationCodeTextField.attributedPlaceholder = [self changePlaceholderColor:self.verificationCodeTextField];
}

- (NSMutableAttributedString *)changePlaceholderColor:(UITextField *)placeholder {
    NSMutableAttributedString *placeholder_str = [[NSMutableAttributedString alloc] initWithString:placeholder.placeholder];
    [placeholder_str addAttribute:NSForegroundColorAttributeName
                        value:[UIColor jk_colorWithHexString:@"A6A6A6"]
                        range:NSMakeRange(0, placeholder.placeholder.length)];
    return placeholder_str;
}


- (void)et_bindViewModel {
    RAC(self.viewModel, phoneNumber) = self.phoneNumberTextField.rac_textSignal;
    RAC(self.viewModel, verificationCode) = self.verificationCodeTextField.rac_textSignal;
    RAC(self.verificationCodeBtn, enabled) = self.viewModel.validVerificationCodeSignal;
    RAC(self.loginBtn, enabled) = self.viewModel.validLoginSignal;
    
    @weakify(self)
    
    [self.viewModel.hashCodeCommand execute:nil];
    [[[self.verificationCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        @strongify(self)
        [self.verificationCodeBtn jk_startTime:59 title:@"重新获取" waitTittle:@"秒"];
    }] subscribeNext:^(id x) {
        [[self.viewModel.verigicationCodeCommand execute:nil] subscribeNext:^(id responseObject) {
            NSLog(@"%@", responseObject[@"Msg"]);
        }];
    }];
    
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        @strongify(self)
        
//        self.loginBtn.enabled = NO;
    }] subscribeNext:^(id x) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.label.text = @"Loading...";
//        //        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
//
//        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
//        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
//        hud.labelText = @"Loding...";
//        hud.dimBackground = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            // 完成一些操作后
            [[self.viewModel.loginCommand execute:nil] subscribeNext:^(id responseObject) {
                @strongify(self)
                self.loginBtn.enabled = YES;
                if ([responseObject[@"Status"] integerValue] == 200) {
                    [MobClick profileSignOff];
                    [MobClick profileSignInWithPUID:[responseObject[@"Data"][@"UserID"] stringValue]];
                    [self dismiss];
                } else {
                    [MBProgressHUD showMessage:@"登录失败"];
                }
                NSLog(@"%@", responseObject[@"Msg"]);
            }];

            //            [hud removeFromSuperview];
        } completionBlock:nil];
    }];
    
    [self.viewModel.thirdLoginCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [MobClick profileSignOff];
            switch ([responseObject[@"Data"][@"LoginType"] integerValue]) {
                case 1: {
                    [MobClick profileSignInWithPUID:[responseObject[@"Data"][@"UserID"] stringValue] provider:@"QQ"];
                }
                    break;
                case 2: {
                    [MobClick profileSignInWithPUID:[responseObject[@"Data"][@"UserID"] stringValue] provider:@"Wechat"];
                }
                    break;
                case 3: {
                    [MobClick profileSignInWithPUID:[responseObject[@"Data"][@"UserID"] stringValue] provider:@"SinaWeibo"];
                }
                    break;
                default:
                    break;
            }
            [MBProgressHUD showMessage:@"登录成功"];
            [self dismiss];
        }
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recover:(id)sender {
    [self dismiss];
}

- (IBAction)privacy:(id)sender {
    ETWebVC *webVC = [[ETWebVC alloc] init];
    webVC.webType = ETWebTypeAgreement;
    webVC.url = [NSString stringWithFormat:@"%@%@", INTERFACE_URL, HTML_PrivacyPolicy];
    ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:webVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

- (IBAction)wechatLogin:(id)sender {
//    [MBProgressHUD showHUDAddedTo:ETWindow animated:YES];
//    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        [MBProgressHUD hideHUDForView:ETWindow animated:YES];
//        if (state == SSDKResponseStateSuccess) {
//            [self.viewModel.thirdLoginCommand execute:@{@"LoginType" : @(2),
//                                                        @"OpenID" : user.uid,
//                                                        @"NickName" : user.nickname,
//                                                        @"ProfilePicture" : user.icon}];
//        } else if (state == SSDKResponseStateCancel) {
//            [MBProgressHUD showMessage:@"您拒绝了授权"];
//        } else {
//            if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
//                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
//            }
//            [MBProgressHUD showMessage:@"登录失败"];
//        }
//    }];
    [ShareSDK authorize:SSDKPlatformTypeWechat
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                   [MBProgressHUD hideHUDForView:ETWindow animated:YES];
                   if (state == SSDKResponseStateSuccess) {
                       [self.viewModel.thirdLoginCommand execute:@{@"LoginType" : @(2),
                                                                   @"OpenID" : user.uid,
                                                                   @"NickName" : user.nickname,
                                                                   @"ProfilePicture" : user.icon}];
                   } else if (state == SSDKResponseStateCancel) {
                       [MBProgressHUD showMessage:@"您拒绝了授权"];
                   } else {

                       [MBProgressHUD showMessage:@"登录失败"];
                   }
               }];

}

- (IBAction)weiboLogin:(id)sender {
    [ShareSDK authorize:SSDKPlatformTypeSinaWeibo
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
             if (state == SSDKResponseStateSuccess) {
                 [self.viewModel.thirdLoginCommand execute:@{@"LoginType" : @(3),
                                                             @"OpenID" : user.uid,
                                                             @"NickName" : user.nickname,
                                                             @"ProfilePicture" : user.icon}];
             } else if (state == SSDKResponseStateCancel) {
                 [MBProgressHUD showMessage:@"您拒绝了授权"];
             } else {
                 [MBProgressHUD showMessage:@"登录失败"];
             }
         }];
}

- (IBAction)qqLogin:(id)sender {
    [ShareSDK authorize:SSDKPlatformTypeQQ
               settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                   if (state == SSDKResponseStateSuccess) {
                       [self.viewModel.thirdLoginCommand execute:@{@"LoginType" : @(1),
                                                                   @"OpenID" : user.uid,
                                                                   @"NickName" : user.nickname,
                                                                   @"ProfilePicture" : user.icon}];
                   } else if (state == SSDKResponseStateCancel) {
                       [MBProgressHUD showMessage:@"您拒绝了授权"];
                   } else {
                       [MBProgressHUD showMessage:@"登录失败"];
                   }
               }];
}

- (void)thirdLogin {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
