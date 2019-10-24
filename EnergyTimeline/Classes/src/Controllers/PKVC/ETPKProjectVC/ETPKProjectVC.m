//
//  ETPKProjectVC.m
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectVC.h"
#import "ZJScrollPageView.h"

#import "ETPKProjectHeaderView.h"

#import "ETPKProjectRankVC.h"
#import "ETPKProjectRecordVC.h"

#import "ETReportPostVC.h"
#import "ETReportPostNavController.h"

#import "ETTrainTargetVC.h"

#import "ETPKReportPopView.h"

#import "ETRefreshGifHeader.h"

static NSString * const segmentViewColorHexString = @"E05954";

static NSString * const cellID = @"cellID";

static CGFloat const headViewHeight = 240.0;

NSString * const ETTableViewDidLeaveFromTopNotification = @"ETPKProjectTableViewDidLeaveFromTopNotification";

@interface ETPKProjectTableView : UITableView

@end

@implementation ETPKProjectTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end

@interface ETPKProjectVC () <ZJScrollPageViewDelegate, ETViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZJSegmentStyle *style;

@property (nonatomic, strong) ZJScrollSegmentView *segmentView;

@property (nonatomic, strong) ZJContentView *contentView;

@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, strong) UIView *sectionView;

@property (nonatomic, strong) UIButton *clockInButton;

@property (nonatomic, strong) ETPKProjectHeaderView *headerView;

@property (nonatomic, strong) ETPKProjectTableView *mainTableView;

@property (nonatomic, strong) UIScrollView *currentScrollView;

@end

@implementation ETPKProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.equalTo(@30);
    }];

    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.sectionView);
//        make.top.equalTo(weakSelf.sectionView).with.offset(15);
        make.width.equalTo(weakSelf.sectionView.mas_width).multipliedBy(0.5);
        make.height.equalTo(@40);
        
        make.left.equalTo(weakSelf.sectionView).with.offset(20);
        make.bottom.equalTo(weakSelf.clockInButton);
        
    }];
    
    [self.clockInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.sectionView);
//        make.left.equalTo(weakSelf.segmentView.mas_right).with.offset(12);
        
        make.right.equalTo(weakSelf.sectionView).with.offset(-16);
        make.height.equalTo(@50);
        make.width.equalTo(@(IsiPhone5 ? 114 : 134));
    }];
    
    [super updateViewConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainTableView];
    [self.sectionView addSubview:self.segmentView];
    [self.sectionView addSubview:self.clockInButton];
    [self.view addSubview:self.topButton];

    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.topButton.hidden = [self.viewModel.myReportModel.Is_SenPost boolValue];
        self.clockInButton.hidden = ([self.viewModel.model.ProjectID isEqualToString:@"35"] || ([self.viewModel.myReportModel.Limit isEqualToString:@"1"] && [self.viewModel.myReportModel.ReportID boolValue]));
        [self.clockInButton setTitle:([self.viewModel.model.Is_Train boolValue] ? @"开始训练" : @"打卡") forState:UIControlStateNormal];
//        self.clockInButton.hidden = ([self.viewModel.model.ProjectID isEqualToString:@"35"] || [self.viewModel.model.ProjectID isEqualToString:@"50"]);
//        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.refreshSubject subscribeNext:^(NSString *string) {
        @strongify(self)
        if ([self.title isEqualToString:string]) {
            [self.viewModel.myReportDataCommand execute:nil];
            [self.viewModel.refreshRankDataCommand execute:nil];
        }
    }];
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.viewModel.model.ProjectName;
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_didDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETPKProjectHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETPKProjectHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _headerView;
}

- (ETPKProjectTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[ETPKProjectTableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.headerView;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        WS(weakSelf)
        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.myReportDataCommand execute:nil];
            [weakSelf.viewModel.refreshRankDataCommand execute:nil];
            [weakSelf.viewModel.refreshRecordDataCommand execute:nil];
        }];
    }
    return _mainTableView;
}

- (ZJSegmentStyle *)style {
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
//        _style.showCover = YES; // 是否显示遮罩层
//        _style.coverHeight = 40; // 遮罩层的高度
//        _style.coverCornerRadius = 0; // 遮罩层圆角
//        _style.scrollTitle = NO;
//        _style.scrollContentView = NO; // 内容视图是否滚动
//        _style.titleFont = [UIFont systemFontOfSize:12];
//        _style.gradualChangeTitleColor = YES; // 开启颜色渐变,但是同时默认字体颜色和选择时字体颜色必须使用RGB颜色,否则程序崩溃
//        _style.coverBackgroundColor = [UIColor jk_colorWithHexString:segmentViewColorHexString];
//        _style.normalTitleColor = [UIColor jk_colorWithWholeRed:149 green:160 blue:171];
//        _style.selectedTitleColor = [UIColor jk_colorWithWholeRed:255 green:255 blue:255];
        
        _style.showCover = NO; // 是否显示遮罩层
        _style.titleMargin = 30; // 标题之间的间隔
        _style.scrollTitle = YES; // 是否滚动标题
        _style.scaleTitle = YES; // 标题是否可以缩放
        _style.titleBigScale = 1.5; // 标题缩放比例
        _style.scrollContentView = NO; // 内容视图是否滚动
        _style.gradualChangeTitleColor = YES; // 开启颜色渐变,但是同时默认字体颜色和选择时字体颜色必须使用RGB颜色,否则程序崩溃
        _style.titleFont = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        _style.normalTitleColor = [UIColor jk_colorWithWholeRed:149 green:160 blue:171];
        _style.selectedTitleColor = [UIColor jk_colorWithWholeRed:242 green:77 blue:76];
    }
    return _style;
}

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        _segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW * 0.5, 40) segmentStyle:self.style delegate:self titles:@[@"排行榜", @"回顾"] titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
        }];
//        _segmentView.layer.borderWidth = 1;
//        _segmentView.layer.borderColor = [UIColor jk_colorWithHexString:segmentViewColorHexString].CGColor;
//        _segmentView.layer.cornerRadius = 20.0;
//        _segmentView.layer.masksToBounds = YES;
        _segmentView.backgroundColor = ETMainBgColor;
    }
    return _segmentView;
}

- (ZJContentView *)contentView {
    if (!_contentView) {
        CGRect frame = ETScreenB;
//        frame.size.height -= kNavHeight + 64 + kSafeAreaBottomHeight;
        frame.size.height -= kNavHeight + 64;
        _contentView = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView.backgroundColor = ETClearColor;
    }
    return _contentView;
}

- (ETPKProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [[UIButton alloc] init];
        _topButton.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.5];
        [_topButton setTitle:@"您还未发布动态,发布动态可额外获得积分,去发布>>" forState:UIControlStateNormal];
        [_topButton setTitleColor:ETMinorColor forState:UIControlStateNormal];
        _topButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _topButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _topButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _topButton.hidden = YES;
        @weakify(self)
        [[_topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [MobClick event:@"ETReportPostVCEnterClick"];
            ETReportPostVC *postVC = [[ETReportPostVC alloc] init];
            ETReportPostNavController *postNavVC = [[ETReportPostNavController alloc] initWithRootViewController:postVC];
            [self presentViewController:postNavVC animated:YES completion:nil];
        }];
    }
    return _topButton;
}

- (UIView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] init];
        _sectionView.backgroundColor = ETMainBgColor;
    }
    return _sectionView;
}

- (UIButton *)clockInButton {
    if (!_clockInButton) {
        _clockInButton = [[UIButton alloc] init];
        _clockInButton.hidden = YES;
//        [_clockInButton setImage:[UIImage imageNamed:@"pk_clockIn_yellow"] forState:UIControlStateNormal];
        _clockInButton.backgroundColor = ETMarkYellowColor;
        _clockInButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_clockInButton setTitleColor:ETMinorBgColor forState:UIControlStateNormal];
        _clockInButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _clockInButton.layer.cornerRadius = 25;
        @weakify(self)
        [[_clockInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            
            if ([self.viewModel.model.Is_Train boolValue]) {
                ETTrainTargetVC *targetVC = [[ETTrainTargetVC alloc] init];
                targetVC.viewModel.projectID = [self.viewModel.model.ProjectID integerValue];
                [self presentViewController:targetVC animated:YES completion:nil];
            } else {
                ETPKReportPopView *pkReportPopView = [[ETPKReportPopView alloc] initWithFrame:ETScreenB];
                pkReportPopView.model = self.viewModel.model;
                [pkReportPopView.viewModel.reportCompletedSubject subscribeNext:^(id x) {
                    [self.viewModel.myReportDataCommand execute:nil];
                    [self.viewModel.refreshRankDataCommand execute:nil];
                    [self.viewModel.refreshRecordDataCommand execute:nil];
                }];
                [ETWindow addSubview:pkReportPopView];
            }
        }];
    }
    return _clockInButton;
}

#pragma -- ZJScrollPageViewDelegate --

- (NSInteger)numberOfChildViewControllers {
    return 2;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(ETViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    ETViewController<ZJScrollPageViewChildVcDelegate> *childVC = reuseViewController;
    
    if (!childVC) {
        switch (index) {
            case 0: {
                childVC = [[ETPKProjectRankVC alloc] initWithViewModel:self.viewModel];
                childVC.scrollDelegate = self;
            }
                break;
            case 1: {
                childVC = [[ETPKProjectRecordVC alloc] initWithViewModel:self.viewModel];
                childVC.scrollDelegate = self;
            }
            default:
                break;
        }
    }
    return childVC;
}

/** 为了正常显示子视图必须调用这个方法 */
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

-(CGRect)frameOfChildControllerForContainer:(UIView *)containerView {
    return  CGRectInset(containerView.bounds, 20, 20);
}

#pragma mark -- scroll --

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView {
    _currentScrollView = scrollView;
    if (self.mainTableView.contentOffset.y < headViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }
    else {
        self.mainTableView.contentOffset = CGPointMake(0.0f, headViewHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentScrollView && _currentScrollView.contentOffset.y > 0) {
        self.mainTableView.contentOffset = CGPointMake(0.0f, headViewHeight);
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < headViewHeight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ETTableViewDidLeaveFromTopNotification object:nil];

    }
}

#pragma mark -- tableView delegate and datasource --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentView.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = ETClearColor;
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.contentView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionView;
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
