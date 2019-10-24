//
//  ETSetupVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSetupVC.h"
#import "ETSetupView.h"
#import "ETSetupViewModel.h"

#import "ETPopView.h"

#import "ETUserInfoVC.h"
#import "ETMyInfoVC.h"
#import "ETPhoneNoChangeVC.h"
#import "ETCacheVC.h"
#import "ETSuggestVC.h"
#import "ETAboutVC.h"

#import "AppDelegate.h"

@interface ETSetupVC () <ETPopViewDelegate>

@property (nonatomic, strong) ETSetupView *mainView;

@property (nonatomic, strong) ETSetupViewModel *viewModel;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ETSetupVC

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
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self)
//        switch (indexPath.section) {
//            case 1: {
//                ETPhoneNoChangeVC *phoneNoVC = [[ETPhoneNoChangeVC alloc] init];
//                [self.navigationController pushViewController:phoneNoVC animated:YES];
//            }
//                break;
//            case 2: {
//                if (indexPath.row == 1) {
//                    ETSuggestVC *suggestVC = [[ETSuggestVC alloc] init];
//                    [self.navigationController pushViewController:suggestVC animated:YES];
//                } else if (indexPath.row == 2) {
//                    ETAboutVC *aboutVC = [[ETAboutVC alloc] init];
//                    [self.navigationController pushViewController:aboutVC animated:YES];
//                }
//            }
//                break;
//            case 3: {
//                [ETPopView popViewWithDelegate:self Title:@"退出登录" Tip:@"确认退出登录?" SureBtnTitle:@"退出" CancelBtnTitle:@"取消"];
//
//            }
//                break;
//            default:
//                break;
//        }
        if (indexPath.section) {
            [ETPopView popViewWithDelegate:self Title:@"退出登录" Tip:@"确认退出登录?" SureBtnTitle:@"退出" CancelBtnTitle:@"取消"];
        } else {
            switch (indexPath.row) {
                case 0: {
//                    ETMyInfoVC *myInfoVC = [[ETMyInfoVC alloc] init];
//                    [self.navigationController pushViewController:myInfoVC animated:YES];
                    ETUserInfoVC *userInfoVC = [[ETUserInfoVC alloc] init];
                    [self.navigationController pushViewController:userInfoVC animated:YES];
                }
                    break;
                case 1: {
                    ETPhoneNoChangeVC *phoneNoVC = [[ETPhoneNoChangeVC alloc] init];
                    [self.navigationController pushViewController:phoneNoVC animated:YES];
                }
                    break;
                case 2: {
                    ETSuggestVC *suggestVC = [[ETSuggestVC alloc] init];
                    [self.navigationController pushViewController:suggestVC animated:YES];
                }
                    break;
                case 3: {
                    ETCacheVC *cacheVC = [[ETCacheVC alloc] init];
                    [self.navigationController pushViewController:cacheVC animated:YES];
                }
                    break;
                case 5: {
                    ETAboutVC *aboutVC = [[ETAboutVC alloc] init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
        
    }];
    
    [[self.viewModel.logoutEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.appDelegate.tabbarVC setToSelectedIndex:0];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETSetupVC"];
    self.title = @"设置";
    self.view.backgroundColor = ETMainBgColor;
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETSetupVC"];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETSetupView *)mainView {
    if (!_mainView) {
        _mainView = [[ETSetupView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETSetupViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSetupViewModel alloc] init];
    }
    return _viewModel;
}

- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _appDelegate;
}

#pragma mark -- ETPopViewDelegate --

- (void)popViewClickSureBtn {
    [self.viewModel.logoutCommand execute:nil];
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
