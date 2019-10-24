//
//  ETPKVC.m
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKVC.h"
#import "ETPKView.h"
#import "ETPKViewModel.h"

#import "ETSignRankListVC.h"
#import "ETIntegralRankVC.h"

#import "ETReportPKVC.h"
#import "ETReportPKNavController.h"

#import "ETSearchProjectVC.h" // 项目列表页面

#import "ETDailyPKPageVC.h"
#import "ETPKProjectVC.h" // pk项目排行榜和回顾
#import "ETPKProjectPageVC.h"

#import "ETLoginVC.h"

#import "ETPopView.h"
#import "ETRewardView.h"

#import "ETHealthManager.h"

/** 红点 */
#import "UITabBar+Badge.h"

/** 更新与活动弹框 */
#import "ETUpdatesAndActivitiesView.h"

#import "ETRemindView.h"

#import "ETWebVC.h"

#import "ETTrainPopView.h"


/** 训练 */
#import "ETTrainVC.h"
/** 训练目标页面 */
#import "ETTrainTargetVC.h"

/** 一键汇总页面 */
#import "ETReportPKPoolVC.h"

#import "AppDelegate.h"

@interface ETPKVC () <ETTrainPopViewDelegate>

@property (nonatomic, strong) ETPKView *mainView;

@property (nonatomic, strong) ETPKViewModel *viewModel;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ETPKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    //    [self.viewModel]
    [self.viewModel.noticeDataCommand execute:nil];
    
    /** 判断是否显示过气泡 */
//    NSString *pkSignUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"PKSignUIUpdate"];
//    if (!pkSignUpdate) {
    [self updatesAndActivities];
//    }
    
    [[self.viewModel.myCheckInClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETSignRankListVC *signVC = [[ETSignRankListVC alloc] init];
        [self.tabBarController.navigationController pushViewController:signVC animated:YES];
    }];
    
    [[self.viewModel.integralRankSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETIntegralRankVC *integralVC = [[ETIntegralRankVC alloc] init];
        [self.tabBarController.navigationController pushViewController:integralVC animated:YES];
    }];
    
    [[self.viewModel.projectRankSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETPKProjectRankPageClick"];
        ETPKProjectPageVC *pkVC = [[ETPKProjectPageVC alloc] init];
//        pkVC.viewModel.dataArray = self.viewModel.pkDataArray;
//        pkVC.viewModel.currentIndex = indexPath.row;
        pkVC.viewModel.allProject = YES;
        [self.tabBarController.navigationController pushViewController:pkVC animated:YES];
    }];
    
    [[self.viewModel.rightSideClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        ETReportPKVC *reportPKVC = [[ETReportPKVC alloc] init];
//        ETReportPKNavController *reportPKNavC = [[ETReportPKNavController alloc] initWithRootViewController:reportPKVC];
////        reportPKNavC.interactivePopGestureRecognizer.delegate = self;
//        [self presentViewController:reportPKNavC animated:YES completion:nil];
        
        [MobClick event:@"ETPKRightSideClick"];
        ETSearchProjectVC *searchProjectVC = [[ETSearchProjectVC alloc] init];
        ETNavigationController *searchNavVC = [[ETNavigationController alloc] initWithRootViewController:searchProjectVC];
        [self presentViewController:searchNavVC animated:YES completion:nil];

//        ETTrainVC *trainVC = [[ETTrainVC alloc] init];
////        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:trainVC];
//        [self presentViewController:trainVC animated:YES completion:nil];
    }];
    
    [[self.viewModel.projectCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self)
        /** 健康数据上传 */
        [[ETHealthManager sharedInstance] stepAutomaticUpload];
//        ETDailyPKPageVC *pkPageVC = [[ETDailyPKPageVC alloc] init];
//        pkPageVC.projectName = projectName;
//        [self.tabBarController.navigationController pushViewController:pkPageVC animated:YES];
        
//        if (indexPath.row % 2) {
//            [ETRewardView rewardViewWithContent:@"+10积分"];
//        } else {
//            [ETRewardView rewardViewWithContent:@"+10积分" extra:@"恭喜你，额外获得了20积分"];
//        }
        
        //暂时注释
//        ETPKProjectPageVC *pkVC = [[ETPKProjectPageVC alloc] init];
//        pkVC.viewModel.dataArray = self.viewModel.pkDataArray;
//        pkVC.viewModel.currentIndex = indexPath.row;
//        [self.tabBarController.navigationController pushViewController:pkVC animated:YES];
        
        ETDailyPKProjectRankListModel *model = self.viewModel.pkDataArray[indexPath.row];
        if ([model.Is_Train integerValue] && ![model.ReportID integerValue]) {
            ETTrainTargetVC *targetVC = [[ETTrainTargetVC alloc] init];
            targetVC.viewModel.projectID = [model.ProjectID integerValue];
            [self presentViewController:targetVC animated:YES completion:nil];
        } else {
            ETPKProjectPageVC *pkVC = [[ETPKProjectPageVC alloc] init];
            pkVC.viewModel.dataArray = self.viewModel.pkDataArray;
            pkVC.viewModel.currentIndex = indexPath.row;
            [self.tabBarController.navigationController pushViewController:pkVC animated:YES];
        }
        
//        ETTrainTargetVC *targetVC = [[ETTrainTargetVC alloc] init];
////        ETDailyPKProjectRankListModel *model = self.viewModel.pkDataArray[indexPath.row];
//        targetVC.viewModel.projectID = [model.ProjectID integerValue];
//        [self presentViewController:targetVC animated:YES completion:nil];
    }];
    
    [[self.viewModel.pkReportSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        ETReportPKPoolVC *reportPKPoolVC = [[ETReportPKPoolVC alloc] init];
//        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:reportPKPoolVC];
//        [self presentViewController:navVC animated:YES completion:nil];
        [[self.viewModel.pkReportCommand execute:nil] subscribeNext:^(id responseObject) {
            if ([responseObject[@"Status"] integerValue] == 200) {
                if ([responseObject[@"Data"] boolValue]) {
                    ETReportPKPoolVC *reportPKPoolVC = [[ETReportPKPoolVC alloc] init];
                    ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:reportPKPoolVC];
                    [self presentViewController:navVC animated:YES completion:nil];
                } else {
                    [ETPopView popViewWithTip:@"请汇报更多PK项目"];
                }
//                if ([responseObject[@"Data"] integerValue] < 0) {
//                    [ETPopView popViewWithTip:@"请汇报更多PK项目"];
//                } else if ([responseObject[@"Data"] integerValue] == 0) {
//                    [ETPopView popViewWithTip:@"汇报成功"];
//                } else {
//                    [ETRewardView rewardViewWithContent:[NSString stringWithFormat:@"+%@", responseObject[@"Data"]] duration:1.0];
//                }
            }
        }];
    }];
    
    [[self.viewModel.noticeRemindSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        NSString *setupUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MineSetupUIUpdate"];
        if (self.viewModel.noticeNotReadCount) {
            [self.tabBarController.tabBar showBadgeItemOnIndex:4];
        }
    }];
    
    [self.viewModel.firstEnterEndSubject subscribeNext:^(id x) {
        @strongify(self)
        NSMutableArray *imageArr = [NSMutableArray array];
        if (![self.viewModel.firstEnterModel.Is_CheckIn_Remind boolValue]) {
            [imageArr addObject:[NSString stringWithFormat:(IsiPhoneX ? @"remind_pk_signIn_X" : @"remind_pk_signIn")]];
            [self.viewModel.firstEnterUpdCommand execute:@"Is_CheckIn_Remind"];
        }
        if (![self.viewModel.firstEnterModel.Is_First_Train boolValue]) {
            [imageArr addObject:[NSString stringWithFormat:(IsiPhoneX ? @"remind_pk_train_X" : (IsiPhone5 ? @"remind_pk_train_small" : @"remind_pk_train"))]];
            [self.viewModel.firstEnterUpdCommand execute:@"Is_First_Train"];
        }
        if (imageArr.count) {
            [ETRemindView remindImageArr:imageArr];
        }
//        if (![self.viewModel.firstEnterModel.Is_CheckIn_Remind boolValue]) {
//            if (IsiPhoneX) {
//                [ETRemindView remindImageName:@"remind_pk_signIn_X"];
//            } else {
//                [ETRemindView remindImageName:@"remind_pk_signIn"];
//            }
//            [self.viewModel.firstEnterUpdCommand execute:@"Is_CheckIn_Remind"];
//        }
        if (![self.viewModel.firstEnterModel.Is_FirstEditProfile_Remind boolValue] || ![self.viewModel.firstEnterModel.Is_Suggest boolValue]) {
            [self.tabBarController.tabBar showBadgeItemOnIndex:4];
        }
    }];
    
    [self.viewModel.unfinishedTrainSubject subscribeNext:^(id x) {
        @strongify(self)
        ETTrainPopView *popView = [[ETTrainPopView alloc] initWithTitle:@"提示" Content:@"你还有项目尚未完成,\n是否继续训练" LeftBtnTitle:@"结束训练" RightBtnTitle:@"继续训练"];
        popView.delegate = self;
        [ETWindow addSubview:popView];
    }];
    
    /** 引导气泡消失后判断功能更新详情和活动提醒 */
    [[self.viewModel.remindEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self updatesAndActivities];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReportPKCompleted" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        if ([self jk_isVisible]) {
//            NSString *pkReportUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"PKReportUIUpdate"];
//            if (!pkReportUpdate) {
//                if (@available(iOS 11.0, *)) {
//                    [ETRemindView remindImageName:@"remind_pk_report_X"];
//                } else {
//                    [ETRemindView remindImageName:@"remind_pk_report"];
//                }
//                pkReportUpdate = @"2.3";
//                [[NSUserDefaults standardUserDefaults] setObject:pkReportUpdate forKey:@"PKReportUIUpdate"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
            if (![self.viewModel.firstEnterModel.Is_FirstPool boolValue]) {
                if (IsiPhoneX) {
                    [ETRemindView remindImageName:@"remind_pk_report_X"];
                } else {
                    [ETRemindView remindImageName:@"remind_pk_report"];
                }
                [self.viewModel.firstEnterUpdCommand execute:@"Is_FirstPool"];
            }
        }
    }];
}

- (void)updatesAndActivities {
    @weakify(self)
    
    ETUpdatesAndActivitiesView *update = [[ETUpdatesAndActivitiesView alloc] init];
    update.frame = ETWindow.bounds;
    [update.viewModel.activePageSubject subscribeNext:^(NSString *url) {
        @strongify(self)
        if (!User_Status) {
            ETLoginVC *loginVC = [[ETLoginVC alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
            return;
        }
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.url = url;
        webVC.webType = ETWebTypeActivities;
        
        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:webVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    [update.viewModel.functionSubject subscribeNext:^(ETSysModel *model) {
        @strongify(self)
        if (!User_Status) {
            ETLoginVC *loginVC = [[ETLoginVC alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
            return;
        }
        // 1.后台传过来的数据是1,2,3,4并不是从0开始的 2.因为底部选择的坐标2是弹出菜单栏是没有页面的所以要跳过2这个坐标
        NSInteger index = [model.Target integerValue] > 2 ? [model.Target integerValue] : [model.Target integerValue] ? [model.Target integerValue] - 1 : [model.Target integerValue];
        [self.appDelegate.tabbarVC setToSelectedIndex:index];
    }];
    
    [update.viewModel.nothingSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.unfinishedTrainCommand execute:nil];
    }];
    [ETWindow addSubview:update];
}

- (void)et_layoutNavigation {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.viewModel.refreshPKCommand execute:nil];

    if (!User_Status) {
//        [ETRewardView rewardViewWithContent:[NSString stringWithFormat:@"LLLLL"] duration:1];

        ETLoginVC *loginVC = [[ETLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark -- lazyLoad --

- (ETPKView *)mainView {
    if (!_mainView) {
        _mainView = [[ETPKView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETPKViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKViewModel alloc] init];
    }
    return _viewModel;
}

- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _appDelegate;
}

#pragma mark -- ETTrainPopViewDelegate --

- (void)leftButtonClick:(NSString *)string {
    NSLog(@"结束训练");
    [self.viewModel.trainEndCommand execute:nil];
}

- (void)rightButtonClick:(NSString *)string {
    NSLog(@"继续训练");
    ETTrainVC *trainVC = [[ETTrainVC alloc] init];
    trainVC.viewModel.trainID = [self.viewModel.unfinishedTrainModel.TrainID integerValue];
    [self presentViewController:trainVC animated:YES completion:nil];
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

