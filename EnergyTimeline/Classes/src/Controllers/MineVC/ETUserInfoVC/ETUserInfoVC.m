//
//  ETUserInfoVC.m
//  能量圈
//
//  Created by 王斌 on 2017/10/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUserInfoVC.h"
#import "ETUserInfoView.h"
#import "ETUserInfoViewModel.h"

#import "ETPopView.h"

/** 图片压缩 */
#import "UIImage+Compression.h"

@interface ETUserInfoVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) ETUserInfoView *mainView;

@property (nonatomic, strong) ETUserInfoViewModel *viewModel;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation ETUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.profilePictureSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self selectPhotos];
    }];
    
    [[self.viewModel.editEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Title"
//                                                                       message:@"This is an alert."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {
//                                                                  //响应事件
//                                                                  NSLog(@"action = %@", action);
//                                                              }];
//        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action) {
//                                                                 //响应事件
//                                                                 NSLog(@"action = %@", action);
//                                                             }];
//
//        [alert addAction:defaultAction];
//        [alert addAction:cancelAction];
//        [self presentViewController:alert animated:YES completion:nil];
        
        NSString *userInfoEditID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MineUserInfoFirstEditID"];
        
        if (!userInfoEditID) {
            [ETPopView popViewWithTitle:@"设置成功!" Tip:@"获得以下奖励:50积分"];
            userInfoEditID = User_ID;
            [[NSUserDefaults standardUserDefaults] setObject:userInfoEditID forKey:@"MineUserInfoFirstEditID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [ETPopView popViewWithTip:@"修改成功"];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)et_layoutNavigation {
    self.title = @"个人资料";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithTitle:@"完成"];
//    self.navigationController.
//    self.navigationController.navigationBar.tintColor = ETBlackColor;
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    if ([self.viewModel.model.Email jk_isEmailAddress]) {
        [self.viewModel.editInfoCommand execute:nil];
    } else {
        [ETPopView popViewWithTip:@"无效邮箱"];
    }
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
    viewController.navigationController.navigationBar.layer.shadowColor = ETWhiteColor.CGColor;
    viewController.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    viewController.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *resultImage = [UIImage compressImage:image toKilobyte:500];
    self.viewModel.image = resultImage;
    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.5);
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self.viewModel.uploadProfilePictureCommand execute:imageData];
}

#pragma mark -- lazyLoad --

- (ETUserInfoView *)mainView {
    if (!_mainView) {
        _mainView = [[ETUserInfoView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETUserInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETUserInfoViewModel alloc] init];
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
