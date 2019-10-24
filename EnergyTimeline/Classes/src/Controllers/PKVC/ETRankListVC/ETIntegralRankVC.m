//
//  ETIntegralRankVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralRankVC.h"
#import "ETIntegralRankView.h"
#import "ETIntegralRankViewModel.h"

#import "ETHomePageVC.h"
#import "ETIntegralRecordVC.h"
#import "ETWebVC.h"

@interface ETIntegralRankVC ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) ETIntegralRankView *mainView;

@property (nonatomic, strong) ETIntegralRankViewModel *viewModel;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@end

@implementation ETIntegralRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(weakSelf.view);
//        make.height.equalTo(@108);
//    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@kNavHeight);
//        make.left.right.bottom.equalTo(weakSelf.view);
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)et_addSubviews {
//    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [[self.viewModel.integralRuleSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETIntegralRuleClick_IntegralRankVC"];
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypeAgreement;
        webVC.url = [NSString stringWithFormat:@"%@%@", INTERFACE_URL, HTML_IntegralRule];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.viewModel.refreshScrollSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(UIScrollView *scrollView) {
        @strongify(self)
        if (scrollView.contentOffset.y >= 155 && !self.viewModel.slideBottom) {
            self.viewModel.slideBottom = YES;
            self.navigationItem.titleView = self.segmentControl;
            self.view.backgroundColor = ETMinorBgColor;
        } else if (scrollView.contentOffset.y < 155 && self.viewModel.slideBottom) {
            self.viewModel.slideBottom = NO;
            self.navigationItem.titleView = nil;
            self.view.backgroundColor = ETMainBgColor;
        }
    }];
    
    [[self.viewModel.syncSegmentSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *index) {
        @strongify(self)
        self.segmentControl.selectedSegmentIndex = [index integerValue];
    }];
    
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETRankModel *model) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [model.UserID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETIntegralRankVC"];
    self.title = @"积分排行";
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_White];
    [self setupRightNavBarWithimage:@"mine_integralRecord_white"];
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETIntegralRankVC"];
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    [MobClick event:@"ETIntegralRecordVC"];
    ETIntegralRecordVC *integralRecordVC = [[ETIntegralRecordVC alloc] init];
    [self.navigationController pushViewController:integralRecordVC animated:YES];
}

#pragma mark -- lazyLoad --

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, ETScreenW, 140) andColors:@[[UIColor colorWithHexString:@"f65e5f"], [UIColor colorWithHexString:@"fccacb"]]];
    }
    return _topView;
}

- (ETIntegralRankView *)mainView {
    if (!_mainView) {
        _mainView = [[ETIntegralRankView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETIntegralRankViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETIntegralRankViewModel alloc] init];
    }
    return _viewModel;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"世界排名", @"好友排名"]];
        _segmentControl.frame = CGRectMake(0, 0, 185, 32);
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.layer.cornerRadius = 16;
        _segmentControl.layer.borderWidth = 1;
        _segmentControl.layer.borderColor = ETMinorColor.CGColor;
        _segmentControl.clipsToBounds = YES;
        _segmentControl.tintColor = ETMinorColor;
        NSDictionary *selectedTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName : ETWhiteColor};
        NSDictionary *unselectTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName : ETTextColor_Fourth};
        [_segmentControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
        [_segmentControl setTitleTextAttributes:unselectTextAttributes forState:UIControlStateNormal];
        _segmentControl.apportionsSegmentWidthsByContent = NO;
        @weakify(self)
        [[_segmentControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.syncSegmentSubject sendNext:[NSNumber numberWithInteger:_segmentControl.selectedSegmentIndex]];
        }];
    }
    return _segmentControl;
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
