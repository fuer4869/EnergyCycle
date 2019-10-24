//
//  ETEnergyTimelineVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETEnergyTimelineVC.h"
#import "ETLogPostListVC.h"
#import "ETPromisePostListVC.h"
#import "ETFollowPostListVC.h"

#import "PostModel.h"

#import "UserModel.h"

/** 跳转页面 */
#import "SinglePromiseDetailsVC.h"
#import "ETWebVC.h"
#import "ETHomePageVC.h"

#import "ETNavigationController.h"

/** 登陆 */
#import "ETLoginVC.h"

/** 更新与活动弹框 */
#import "ETUpdatesAndActivitiesView.h"

#import "AppDelegate.h"

typedef enum : NSUInteger {
    ETPostListTypeLog = 0,
    ETPostListTypePromise,
    ETPostListTypeFollow,
} ETPostListType;

static NSString * const segmentPostSelect               = @"et_segment_post_select";
static NSString * const segmentPostUnselected           = @"et_segment_post_unselected";
static NSString * const segmentPromiseSelect            = @"et_segment_promise_select";
static NSString * const segmentPromiseUnselected        = @"et_segment_promise_unselected";
static NSString * const segmentAttentionSelect          = @"et_segment_attention_select";
static NSString * const segmentAttentionUnselected      = @"et_segment_attention_unselected";


@interface ETEnergyTimelineVC () <UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ETLogPostListVC *logVC;
@property (nonatomic, strong) ETPromisePostListVC *promiseVC;
@property (nonatomic, strong) ETFollowPostListVC *followVC;

@property (nonatomic, assign) ETPostListType listType;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ETEnergyTimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- private --

- (void)et_addSubviews {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.segControl];
    [self.scrollView addSubview:self.logVC.view];
    [self.scrollView addSubview:self.promiseVC.view];
    [self.scrollView addSubview:self.followVC.view];
    
    WS(weakSelf)
    [self.segControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view).with.offset(30);
        make.right.equalTo(weakSelf.view).with.offset(-30);
        make.top.equalTo(@(kStatusBarHeight));
        make.height.equalTo(@(kTopBarHeight));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.segControl.mas_bottom);
        make.bottom.equalTo(weakSelf.view).offset(-kTabBarHeight);
        make.left.right.equalTo(weakSelf.view);
    }];
    
    [self.logVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollView);
        make.top.equalTo(weakSelf.segControl.mas_bottom);
        make.bottom.equalTo(weakSelf.view).offset(-kTabBarHeight);
        make.width.equalTo(ETScreenW);
    }];
    
    [self.promiseVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollView).offset(ETScreenW);
        make.top.equalTo(weakSelf.segControl.mas_bottom);
        make.bottom.equalTo(weakSelf.view).offset(-kTabBarHeight);
        make.width.equalTo(ETScreenW);
    }];
    
    [self.followVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollView).offset(ETScreenW * 2);
        make.top.equalTo(weakSelf.segControl.mas_bottom);
        make.bottom.equalTo(weakSelf.view).offset(-kTabBarHeight);
        make.width.equalTo(ETScreenW);
    }];

}

- (void)et_bindViewModel {
    @weakify(self)
    
//    ETUpdatesAndActivitiesView *update = [[ETUpdatesAndActivitiesView alloc] init];
//    update.frame = ETWindow.bounds;
//    [update.viewModel.activePageSubject subscribeNext:^(NSString *url) {
//        @strongify(self)
//        if (!User_Status) {
//            ETLoginVC *loginVC = [[ETLoginVC alloc] init];
//            [self presentViewController:loginVC animated:YES completion:nil];
//            return;
//        }
//        ETWebVC *webVC = [[ETWebVC alloc] init];
//        webVC.url = url;
//        webVC.webType = ETWebTypeActivities;
//
//        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:webVC];
//        [self presentViewController:navVC animated:YES completion:nil];
//    }];
//
//    [update.viewModel.functionSubject subscribeNext:^(ETSysModel *model) {
//        @strongify(self)
//        if (!User_Status) {
//            ETLoginVC *loginVC = [[ETLoginVC alloc] init];
//            [self presentViewController:loginVC animated:YES completion:nil];
//            return;
//        }
//        // 1.后台传过来的数据是1,2,3,4并不是从0开始的 2.因为底部选择的坐标2是弹出菜单栏是没有页面的所以要跳过2这个坐标
//        NSInteger index = [model.Target integerValue] > 2 ? [model.Target integerValue] : [model.Target integerValue] ? [model.Target integerValue] - 1 : [model.Target integerValue];
//        [self.appDelegate.tabbarVC setToSelectedIndex:index];
//    }];
//    [ETWindow addSubview:update];
    
    
    [[self.backListTopSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        switch (self.listType) {
            case 0: {
                [self.logVC.viewModel.backListTopSubject sendNext:nil];
            }
                break;
            case 1: {
                [self.promiseVC.viewModel.backListTopSubject sendNext:nil];
            }
                break;
            case 2: {
                [self.followVC.viewModel.backListTopSubject sendNext:nil];
            }
                break;
            default:
                break;
        }
    }];
    
    [[self.logVC.viewModel.headerCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(UserModel *model) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [model.UserID integerValue];
        [self.tabBarController.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [[self.promiseVC.viewModel.headerCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PromiseModel *model) {
        @strongify(self)
        SinglePromiseDetailsVC *spdVC = [[SinglePromiseDetailsVC alloc] init];
        spdVC.targetID = [model.TargetID integerValue];
        spdVC.model = model;
        [self.tabBarController.navigationController pushViewController:spdVC animated:YES];
    }];
    
    [[self.logVC.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        @strongify(self)
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypePost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.tabBarController.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.promiseVC.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        @strongify(self)
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypePost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.tabBarController.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.followVC.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        @strongify(self)
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypePost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.tabBarController.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.logVC.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.tabBarController.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [[self.promiseVC.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.tabBarController.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [[self.followVC.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.tabBarController.navigationController pushViewController:homePageVC animated:YES];
    }];
}

- (void)segControl:(HMSegmentedControl *)segControl {
    [UIView animateWithDuration:0.5 animations:^{
        [self setupListType:segControl.selectedSegmentIndex];
        self.scrollView.contentOffset = CGPointMake(ETScreenW * segControl.selectedSegmentIndex, self.scrollView.contentOffset.y);
    }];
}

- (void)et_layoutNavigation {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / ETScreenW;
    [self setupListType:index];
    [self.segControl setSelectedSegmentIndex:index animated:YES];
}

- (void)setupListType:(NSInteger)index {
    switch (index) {
        case 0: {
            self.listType = ETPostListTypeLog;
            [MobClick beginLogPageView:@"ETLogPostListVC"];
            [MobClick endLogPageView:@"ETPromisePostListVC"];
            [MobClick endLogPageView:@"ETFollowPostListVC"];
        }
            break;
        case 1: {
            self.listType = ETPostListTypePromise;
            [MobClick endLogPageView:@"ETLogPostListVC"];
            [MobClick beginLogPageView:@"ETPromisePostListVC"];
            [MobClick endLogPageView:@"ETFollowPostListVC"];
        }
            break;
        case 2: {
            self.listType = ETPostListTypeFollow;
            [MobClick endLogPageView:@"ETLogPostListVC"];
            [MobClick endLogPageView:@"ETPromisePostListVC"];
            [MobClick beginLogPageView:@"ETFollowPostListVC"];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- lazyLoad --

- (HMSegmentedControl *)segControl {
    if (!_segControl) {
//        _segControl = [[HMSegmentedControl alloc]
//                       initWithSectionImages:
//                       @[[UIImage imageNamed:segmentPostUnselected], [UIImage imageNamed:segmentPromiseUnselected], [UIImage imageNamed:segmentAttentionUnselected]]
//                       sectionSelectedImages:
//                       @[[UIImage imageNamed:segmentPostSelect], [UIImage imageNamed:segmentPromiseSelect], [UIImage imageNamed:segmentAttentionSelect]]];
        _segControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"动态", @"公众承诺", @"我的关注"]];
        _segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segControl.backgroundColor = ETMainBgColor;
        _segControl.titleTextAttributes = @{NSForegroundColorAttributeName : ETTextColor_Fourth, NSFontAttributeName : [UIFont boldSystemFontOfSize:12]};
        _segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ETTextColor_First, NSFontAttributeName : [UIFont boldSystemFontOfSize:12]};
        _segControl.selectionIndicatorColor = ETTextColor_First;
        _segControl.selectionIndicatorColor = ETWhiteColor;
        _segControl.selectionIndicatorHeight = 2;
//        _segControl.segmentEdgeInset = UIEdgeInsetsMake(0, 100, 0, 100);
//        _segControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 70);
        _segControl.selectedSegmentIndex = 0; // 设置默认显示的视图
        [self setupListType:_segControl.selectedSegmentIndex];
        [_segControl addTarget:self action:@selector(segControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(ETScreenW * 3, 0);
        _scrollView.contentOffset = CGPointMake(0, 0); // 设置默认显示的视图
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = ETMainBgColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

#pragma mark -- lazyLoad --

- (ETLogPostListVC *)logVC {
    if (!_logVC) {
        _logVC = [[ETLogPostListVC alloc] init];
    }
    return _logVC;
}

- (ETPromisePostListVC *)promiseVC {
    if (!_promiseVC) {
        _promiseVC = [[ETPromisePostListVC alloc] init];
    }
    return _promiseVC;
}

- (ETFollowPostListVC *)followVC {
    if (!_followVC) {
        _followVC = [[ETFollowPostListVC alloc] init];
    }
    return _followVC;
}

- (AppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return _appDelegate;
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
