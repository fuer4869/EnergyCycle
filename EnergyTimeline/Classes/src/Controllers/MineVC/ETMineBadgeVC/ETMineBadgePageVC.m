//
//  ETMineBadgePageVC.m
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineBadgePageVC.h"

#import "ETMineBadgeVC.h"
#import "ETMineBadgeView.h"
#import "ETMineBadgeViewModel.h"
#import "ETMineBadgeHeaderView.h"

#import "ZJScrollPageView.h"

#import "ETBadgeView.h"

static NSString * const cellIdentifier = @"cellIdentifier";

@interface ETMineBadgePageVC () <ZJScrollPageViewDelegate>

@property (nonatomic, strong) ZJSegmentStyle *style;

@property (nonatomic, strong) ZJScrollSegmentView *segmentView;

@property (nonatomic, strong) ZJContentView *contentView;

@property (nonatomic, strong) ETMineBadgeViewModel *viewModel;

@property (nonatomic, strong) ETMineBadgeHeaderView *headerView;

@end

@implementation ETMineBadgePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
    // Do any additional setup after loading the view from its nib.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(124 + kNavHeight));
    }];

    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.contentView];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self)
    [[self.viewModel.refreshEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        self.headerView.viewModel = self.viewModel;
    }];
    
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETBadgeModel *model) {
        [ETBadgeView badgeViewWithModel:model];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETMineBadgeVC"];
    self.navigationController.navigationBar.translucent = YES;
    [self setupLeftNavBarWithimage:ETWhiteBack];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETMineBadgeVC"];
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ZJSegmentStyle *)style {
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
        _style.showLine = YES;
        _style.scrollLineHeight = 5;
        _style.autoAdjustTitlesWidth = YES;
        _style.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _style.scrollLineColor = ETMarkYellowColor;
        _style.selectedTitleColor = ETMarkYellowColor;
//        _style.normalTitleColor = [[UIColor jk_colorWithHexString:@"000000"] colorWithAlphaComponent:0.7];
        _style.normalTitleColor = ETTextColor_Fourth;
    }
    return _style;
}

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        WS(weakSelf)
        _segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 124 + kNavHeight - 40, ETScreenW, 40) segmentStyle:self.style delegate:self titles:@[@"汇报", @"早起", @"签到"] titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0) animated:YES];
        }];
        _segmentView.backgroundColor = ETClearColor;
    }
    return _segmentView;
}

- (ZJContentView *)contentView {
    if (!_contentView) {
        CGRect frame = ETScreenB;
        frame.origin.y += 124 + kNavHeight;
        frame.size.height -= 124 + kNavHeight;
        _contentView = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView.backgroundColor = ETClearColor;
    }
    return _contentView;
}

- (ETMineBadgeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMineBadgeViewModel alloc] init];
    }
    return _viewModel;
}

- (ETMineBadgeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETMineBadgeHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _headerView;
}

#pragma -- ZJScrollPageViewDelegate --

- (NSInteger)numberOfChildViewControllers {
    return 3;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(ETMineBadgeVC<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    ETMineBadgeVC<ZJScrollPageViewChildVcDelegate> *childVC = reuseViewController;
    
    if (!childVC) {
        childVC = [[ETMineBadgeVC alloc] initWithViewModel:self.viewModel];
        childVC.badgeType = index + 1;
    }
    return childVC;
}

/** 为了正常显示子视图必须调用这个方法 */
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return IsiPhoneX;
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
