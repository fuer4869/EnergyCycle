//
//  ETFindVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETFindVC.h"
#import "ETFindView.h"
#import "ETFindViewModel.h"
#import "ETRadioViewModel.h"

#import "ETNavigationController.h"
#import "ETSearchVC.h"
#import "ETRadioVC.h"

#import "ETBannerModel.h"
#import "PostModel.h"

#import "ETWebVC.h"
#import "ETHomePageVC.h"

#import "RadioDurationTimeVC.h"
#import "RadioPlaySettingVC.h"

@interface ETFindVC ()

@property (nonatomic, strong) ETFindView *mainView;

@property (nonatomic, strong) ETFindViewModel *viewModel;

@property (nonatomic, strong) ETRadioViewModel *radioViewModel;

@end

@implementation ETFindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-50);
    }];
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.searchSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETSearchVC *searchVC = [[ETSearchVC alloc] init];
        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:searchVC];
        [self presentViewController:navVC animated:NO completion:nil];
    }];
    
//    [[self.viewModel.bannerCellClickSubjet takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETBannerModel *model) {
//        @strongify(self)
//        ETWebVC *webVC = [[ETWebVC alloc] init];
//        webVC.titleName = model.BannerName;
//        webVC.url = model.BannerContent;
//        [self.tabBarController.navigationController pushViewController:webVC animated:YES];
//    }];
    
    [[self.viewModel.topBannerCellClickSubjet takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETBannerModel *model) {
        @strongify(self)
        NSDictionary *dic = @{@"BannerType" : @"top", @"BannerID" : model.BannerID, @"BannerName" : model.BannerName, @"BannerContent" : model.BannerContent};
        [MobClick event:@"BannerClick" attributes:dic];
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.url = model.BannerContent;
        [self.tabBarController.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.viewModel.bottomBannerCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETBannerModel *model) {
        @strongify(self)
        NSDictionary *dic = @{@"BannerType" : @"bottom", @"BannerID" : model.BannerID, @"BannerName" : model.BannerName, @"BannerContent" : model.BannerContent};
        [MobClick event:@"BannerClick" attributes:dic];
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.url = model.BannerContent;
        [self.tabBarController.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.radioViewModel.radioVCSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"MoreRadioClick"];
        ETRadioVC *radioVC = [[ETRadioVC alloc] initWithViewModel:self.radioViewModel];
        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:radioVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    [[self.radioViewModel.radioPlayVCSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"RadioSetPlayClick"];
        RadioPlaySettingVC *playVC = [[RadioPlaySettingVC alloc] init];
        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:playVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    [[self.radioViewModel.radioDurationTimeVCSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [MobClick event:@"RadioSetStopClick"];
        RadioDurationTimeVC *durationVC = [[RadioDurationTimeVC alloc] init];
        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:durationVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    /** 帖子详情 */
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        NSDictionary *dic = @{@"PostTitle" : model.PostTitle};
        [MobClick event:@"ETFindVCClick" attributes:dic];
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypeRecommendPost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.tabBarController.navigationController pushViewController:webVC animated:YES];
    }];
    
    /** 个人主页 */
    [[self.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.tabBarController.navigationController pushViewController:homePageVC animated:YES];
    }];
    
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETFindVC"];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    
//    [self setStatusBarStyle:UIStatusBarStyleContrast];
    
    [self setupRightNavBarWithimage:@"search_gray"];
    self.title = @"发现";
//    [self setStatusBarStyle:UIStatusBarStyleContrast];
//    self.navigationController.navigationBar.backgroundColor = ETMainBgColor;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:ETScreenB andColors:@[[UIColor colorWithHexString:@"F0CBCF"], [UIColor colorWithHexString:@"AAEFF5"]]];
    self.view.backgroundColor = ETMainBgColor;
    
    [self.radioViewModel.replaceEndSubject sendNext:nil];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETFindVC"];
    [self resetNavigation];
}

- (void)rightAction {
    [self.viewModel.searchSubject sendNext:nil];
}

#pragma mark -- lazyLoad --

- (ETFindView *)mainView {
    if (!_mainView) {
        _mainView = [[ETFindView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETFindViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETFindViewModel alloc] init];
        _viewModel.radioViewModel = self.radioViewModel;
    }
    return _viewModel;
}

- (ETRadioViewModel *)radioViewModel {
    if (!_radioViewModel) {
        _radioViewModel = [[ETRadioViewModel alloc] init];
    }
    return _radioViewModel;
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
