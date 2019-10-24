//
//  ETMineVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineVC.h"
#import "ETMineView.h"
#import "ETMineViewModel.h"

#import "UITabBar+Badge.h"

#import "ETHomePageVC.h"

#import "ETNavigationController.h"
#import "ViewController.h"

#import "ETLoginVC.h"

#import "ETInviteCodeVC.h"
#import "ETNoticeCenterVC.h"
#import "ETNoticeVC.h"
#import "ETMyInfoVC.h"
#import "ETDraftsVC.h"
#import "ETIntegralRecordVC.h"
#import "ETSetupVC.h"
#import "ETIntegralRankVC.h"
#import "ETIntegralMallVC.h"
#import "ETWebVC.h"


#import "ETMineBadgePageVC.h"
#import "ETBadgeRulesVC.h"

#import "ETProjectChartVC.h"

#import "ETDailyPKPageVC.h"
#import "ETOpinionVC.h"

#import "ETPopView.h"

#import "ETHealthManager.h"

/** 图片压缩 */
#import "UIImage+Compression.h"

@interface ETMineVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) ETMineView *mainView;

@property (nonatomic, strong) ETMineViewModel *viewModel;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation ETMineVC

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent=YES;
//    
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    button1.frame = CGRectMake(self.view.center.x, self.view.center.y, 200, 40);
//    button1.backgroundColor = [UIColor blueColor];
//    [button1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button1];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)click1 {
    ViewController *vc = [[ViewController alloc] init];
    vc.title = @"测试";
    [self.tabBarController.navigationController pushViewController:vc animated:YES];
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-kTabBarHeight);
    }];
    
    [super updateViewConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -- private --

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_getNewData {
    [self.viewModel.userDataCommand execute:nil];
    [self.viewModel.myLikeCommand execute:nil];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.mineHomePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETHomePageVC"];
        ETHomePageVC *homepageVC = [[ETHomePageVC alloc] init];
        homepageVC.viewModel.userID = 0;
        [self.tabBarController.navigationController pushViewController:homepageVC animated:YES];
    }];
    
    [[self.viewModel.profilePictureSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self selectPhotos];
    }];
    
    [[self.viewModel.setupSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETSetupVC *setupVC = [[ETSetupVC alloc] init];
        [self.tabBarController.navigationController pushViewController:setupVC animated:YES];
    }];
    
    [[self.viewModel.noticeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        ETNoticeVC *noticeVC = [[ETNoticeVC alloc] init];
//        [self.tabBarController.navigationController pushViewController:noticeVC animated:YES];
        [MobClick event:@"ETNoticeCenterVC"];
        ETNoticeCenterVC *noticeCenterVC = [[ETNoticeCenterVC alloc] init];
        [self.tabBarController.navigationController pushViewController:noticeCenterVC animated:YES];
    }];
    
    [[self.viewModel.myInfoSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETMyInfoVC"];
        ETMyInfoVC *myInfoVC = [[ETMyInfoVC alloc] init];
        [self.tabBarController.navigationController pushViewController:myInfoVC animated:YES];
    }];
    
    [[self.viewModel.draftsSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETDraftsVC"];
        ETDraftsVC *drafrsVC = [[ETDraftsVC alloc] init];
        [self.tabBarController.navigationController pushViewController:drafrsVC animated:YES];
    }];
    
    [[self.viewModel.integralRecordSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETIntegralRecordVC"];
        ETIntegralRecordVC *integralRecordVC = [[ETIntegralRecordVC alloc] init];
        [self.tabBarController.navigationController pushViewController:integralRecordVC animated:YES];
    }];
    
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
//        if (!indexPath.section) {
//            switch (indexPath.row) {
//                case 1: {
//                    ETSetupVC *setupVC = [[ETSetupVC alloc] init];
//                    [self.tabBarController.navigationController pushViewController:setupVC animated:YES];
//                }
//                    break;
//                case 2: {
//                    ETProjectChartVC *projectChartVC = [[ETProjectChartVC alloc] init];
//                    [self.tabBarController.navigationController pushViewController:projectChartVC animated:YES];
//                }
//                    break;
//                default:
//                    break;
//            }
//        } else {
//            switch (indexPath.row) {
//                case 0: {
//                    ETIntegralRankVC *integralRankVC = [[ETIntegralRankVC alloc] init];
//                    [self.tabBarController.navigationController pushViewController:integralRankVC animated:YES];
//                }
//                    break;
//                case 1: {
//                    [MobClick event:@"ETIntegralRuleVCEnterClick"];
//                    ETIntegralRuleVC *integralRuleVC = [[ETIntegralRuleVC alloc] init];
//                    [self.tabBarController.navigationController pushViewController:integralRuleVC animated:YES];
//                }
//                    break;
//                case 2: {
//                    [MobClick event:@"ETIntegralMallVCEnterClick"];
//                    ETIntegralMallViewModel *viewModel = [[ETIntegralMallViewModel alloc] init];
//                    viewModel.model = self.viewModel.model;
//                    ETIntegralMallVC *integralMallVC = [[ETIntegralMallVC alloc] initWithViewModel:viewModel];
//                    [self.tabBarController.navigationController pushViewController:integralMallVC animated:YES];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
        
        switch (indexPath.row) {
            case 0: {
//                UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
//                pastboard.string = self.viewModel.model.InviteCode;
//                [ETPopView popViewWithTip:@"已复制能量源"];
                ETInviteCodeVC *inviteCodeVC = [[ETInviteCodeVC alloc] init];
                [self.tabBarController.navigationController pushViewController:inviteCodeVC animated:YES];
            }
                break;
            case 1 : {
                [MobClick event:@"ETIntegralRuleClick_MineVC"];
                ETWebVC *webVC = [[ETWebVC alloc] init];
                webVC.webType = ETWebTypeAgreement;
                webVC.url = [NSString stringWithFormat:@"%@%@", INTERFACE_URL, HTML_IntegralRule];
                [self.tabBarController.navigationController pushViewController:webVC animated:YES];
            }
                break;
            case 2: {
                ETMineBadgePageVC *badgeVC = [[ETMineBadgePageVC alloc] init];
                [self.tabBarController.navigationController pushViewController:badgeVC animated:YES];
//                ETBadgeRulesVC *badgeRulesVC = [[ETBadgeRulesVC alloc] init];
//                [self.tabBarController.navigationController pushViewController:badgeRulesVC animated:YES];
            }
                break;
            case 3: {
//                /** 健康数据上传 */
//                [[ETHealthManager sharedInstance] stepAutomaticUpload];
//                ETDailyPKPageVC *pkPageVC = [[ETDailyPKPageVC alloc] init];
//                [self.tabBarController.navigationController pushViewController:pkPageVC animated:YES];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"read" forKey:@"New_Function_Mine_Opinion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                ETOpinionVC *opinionVC = [[ETOpinionVC alloc] init];
                [self.tabBarController.navigationController pushViewController:opinionVC animated:YES];
            }
                break;
            case 4: {
                [MobClick event:@"ETIntegralMallVCEnterClick"];
                ETIntegralMallViewModel *viewModel = [[ETIntegralMallViewModel alloc] init];
                viewModel.model = self.viewModel.model;
                ETIntegralMallVC *integralMallVC = [[ETIntegralMallVC alloc] initWithViewModel:viewModel];
                [self.tabBarController.navigationController pushViewController:integralMallVC animated:YES];
            }
                break;
            case 5: {
                ETProjectChartVC *projectChartVC = [[ETProjectChartVC alloc] init];
                [self.tabBarController.navigationController pushViewController:projectChartVC animated:YES];
            }
                break;
            case 6: {
                [[NSUserDefaults standardUserDefaults] setObject:@"read" forKey:@"New_Function_Mine_PersonReport"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [MobClick event:@"ETMineSummaryReport"];
                ETWebVC *webVC = [[ETWebVC alloc] init];
                webVC.webType = ETWebTypeAgreement;
                webVC.url = [NSString stringWithFormat:@"%@%@?UserID=%@&date=%@", INTERFACE_URL, HTML_PKPersonReport, User_ID, [[NSDate date] jk_stringWithFormat:[NSDate jk_ymdFormat]]];
                [self.tabBarController.navigationController pushViewController:webVC animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
    [[self.viewModel.refreshUserModelSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        NSString *setupUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MineSetupUIUpdate"];
        if ([self.viewModel.firstEnterModel.Is_FirstEditProfile_Remind boolValue] && !self.viewModel.noticeNotReadCount && [self.viewModel.firstEnterModel.Is_Suggest boolValue]) {
            [self.tabBarController.tabBar hideBadgeItemOnIndex:4];
        }
    }];
}

- (void)et_layoutNavigation {
//    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = ETClearColor;
    self.navigationController.navigationBar.backgroundColor = ETClearColor;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.viewModel.noticeDataCommand execute:nil];
}

#pragma mark -- private --

- (void)selectPhotos {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- pickerDelegate navigationDelegate --

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationController.navigationBar.translucent = NO;
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [viewController.navigationController.navigationBar setShadowImage:[UIImage new]];
//    viewController.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
    viewController.navigationController.navigationBar.layer.shadowColor = ETWhiteColor.CGColor;
    viewController.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    viewController.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *resultImage = [UIImage compressImage:image toKilobyte:500];
    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.5);
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self.viewModel.uploadProfilePictureCommand execute:imageData];
}

#pragma mark -- lazyLoad --

- (ETMineView *)mainView {
    if (!_mainView) {
        _mainView = [[ETMineView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMineViewModel alloc] init];
    }
    return _viewModel;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
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
