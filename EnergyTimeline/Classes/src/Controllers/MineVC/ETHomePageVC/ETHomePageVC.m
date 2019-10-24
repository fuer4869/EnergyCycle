//
//  ETHomePageVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePageVC.h"
//#import "ETHomePageView.h"
#import "ETHomePageViewModel.h"

/** 第三方控件 */
#import "ZJScrollPageView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

/** 列表头视图 */
#import "ETHomePageHeaderView.h"

/** 子控制器 */
#import "ETHomePageLogVC.h"
#import "ETHomePagePromiseVC.h"
#import "ETHomePagePKVC.h"
#import "ETHomePagePKRecordVC.h"

/** 刷新控件 */
#import "ETHomeRefreshGifHeader.h"

/** 可跳转控制器 */
#import "ETAttentionListVC.h"
#import "ETFansListVC.h"
#import "ETMessageVC.h"
#import "ETWebVC.h"
#import "ETAloneProjectChartVC.h"

/** 帖子模型 */
#import "PostModel.h"

/** pk项目模型 */
#import "ETDailyPKProjectRankListModel.h"

/** 图片压缩 */
#import "UIImage+Compression.h"

static CGFloat const optionHeight = 80.0;
static CGFloat const headerViewHeight = 240.0;
static CGFloat const segmentViewHeight = 44.0;

static NSString * const cellIdentifier = @"cellIdentifier";

static NSString * const mine_log_deep = @"mine_log_deep";
static NSString * const mine_log_shallow = @"mine_log_shallow";
static NSString * const mine_pk_deep = @"mine_pk_deep";
static NSString * const mine_pk_shallow = @"mine_pk_shallow";
static NSString * const mine_pkRecord_deep = @"mine_pkRecord_deep";
static NSString * const mine_pkRecord_shallow = @"mine_pkRecord_shallow";
static NSString * const mine_promise_deep = @"mine_promise_deep";
static NSString * const mine_promise_shallow = @"mine_promise_shallow";

@interface HomePageTableView : UITableView

@end

@implementation HomePageTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end

@interface ETHomePageVC () <ZJScrollPageViewDelegate, NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) HomePageTableView *mainTableView;

@property (strong, nonatomic) ZJScrollSegmentView *segmentView;

@property (nonatomic, strong) ZJContentView *contentView;

@property (nonatomic, strong) UIScrollView *childScrollView;

@property (nonatomic, strong) ETHomePageHeaderView *headerView;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic, strong) NSMutableArray *mainImageArray;

@property (nonatomic, strong) NSMutableArray *minorImageArray;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *titleLabel;

//@property (nonatomic, strong) UIBarButtonItem *pkReport;

@property (nonatomic, assign) BOOL isTop;

@property (nonatomic, assign) BOOL isToPage;

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, assign) BOOL isCoverImg;

@end

@implementation ETHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.equalTo(@(kNavHeight));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.topView);
        make.centerY.equalTo(weakSelf.topView).with.offset(kStatusBarHeight / 2);
    }];
    
//    [self.pkReport mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.topView).with.offset(-10);
//        make.centerY.equalTo(weakSelf.topView).with.offset(kStatusBarHeight / 2);
//    }];
    
    [super updateViewConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
//    if (self.isTop) {
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//        return UIStatusBarStyleDefault;
//    }
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    return UIStatusBarStyleLightContent;
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETHomePageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
//    self.navigationItem.rightBarButtonItem = self.pkReport;

    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    self.viewModel.listType = ETListTypeDailyPK; // 默认跳转PK记录
    
    [self.viewModel.refreshUserModelSubject subscribeNext:^(id x) {
        @strongify(self)
        self.titleLabel.text = self.viewModel.model.NickName;
        self.headerView.viewModel = self.viewModel;
        
        [self.pageFlowView reloadData];
        [self.mainTableView reloadData];
        
        if (self.viewModel.listType) {
            [self.contentView setContentOffSet:CGPointMake(self.contentView.bounds.size.width * (self.viewModel.listType - 1), 0.0) animated:NO];
            [self changePageWithIndex:self.viewModel.listType - 1];
            [self pageData:self.pageFlowView.currentPageIndex];
            self.viewModel.listType = 0;
        }
    }];
    
    [self.viewModel.scrollViewSubject subscribeNext:^(UIScrollView *scrollView) {
        @strongify(self)
        _childScrollView = scrollView;
        if (self.mainTableView.contentOffset.y < headerViewHeight - kNavHeight) {
            scrollView.contentOffset = CGPointZero;
            scrollView.showsVerticalScrollIndicator = NO;
        }
        else {
            self.mainTableView.contentOffset = CGPointMake(0.0f, headerViewHeight - kNavHeight);
            scrollView.showsVerticalScrollIndicator = YES;
        }
    }];
    
    /** 关注列表 */
    [[self.viewModel.attentionListSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETAttentionListVC *attentionVC = [[ETAttentionListVC alloc] init];
        attentionVC.viewModel.userID = self.viewModel.userID;
        [self showViewController:attentionVC sender:nil];
    }];
    
    /** 粉丝列表 */
    [[self.viewModel.fansListSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETFansListVC *fansVC = [[ETFansListVC alloc] init];
        fansVC.viewModel.userID = self.viewModel.userID;
        [self showViewController:fansVC sender:nil];
    }];
    
    /** 私聊 */
    [[self.viewModel.messageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        ETMessageVC *messageVC = [[ETMessageVC alloc] init];
        messageVC.viewModel.toUserNickName = self.viewModel.model.NickName;
        messageVC.viewModel.toUserID = self.viewModel.model.UserID;
        [self showViewController:messageVC sender:nil];
    }];
    
    /** 添加关注 */
    [[self.viewModel.attentionSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.attentionCommand execute:nil];
    }];
    
    /** 替换背景图 */
    [[self.viewModel.setCoverImgSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        self.isCoverImg = YES;
        [self selectPhotos];
    }];
    
    /** 替换头像 */
    [[self.viewModel.setProfilePictureSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        self.isCoverImg = NO;
        [self selectPhotos];
    }];
    
    /** 帖子详情 */
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        @strongify(self)
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypePost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self showViewController:webVC sender:nil];
    }];
    
    /** pk项目数据曲线 */
    [[self.viewModel.pkRecordCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETDailyPKProjectRankListModel *model) {
        @strongify(self)
        ETAloneProjectChartVC *chartVC = [[ETAloneProjectChartVC alloc] init];
        chartVC.viewModel.userID = self.viewModel.userID;
        chartVC.viewModel.projectID = [model.ProjectID integerValue];
        chartVC.title = model.ProjectName;
        
        /** 事件统计 */
        NSDictionary *dic = @{@"ProjectName" : model.ProjectName};
        [MobClick event:@"ETHomePagePKRecordVCClick" attributes:dic];
        
        [self showViewController:chartVC sender:nil];
        
    }];
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_White];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    self.isTop = NO;
    [self preferredStatusBarStyle];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)rightAction {
//    [self.viewModel.pkReportCommand execute:nil];
//}

- (void)pageData:(NSInteger)index {
    switch (index) {
        case 0: {
            if (!self.viewModel.logDataArray.count) [self.viewModel.refreshLogDataCommand execute:nil];
        }
            break;
        case 1: {
            if (!self.viewModel.pkDataArray.count) [self.viewModel.refreshPKDataCommand execute:nil];
        }
            break;
        case 2: {
            if (!self.viewModel.pkRecordDataArray.count) [self.viewModel.refreshPKRecordCommand execute:nil];
        }
            break;
        case 3: {
            if (!self.viewModel.promiseDataArray.count) [self.viewModel.refreshPromiseDataCommand execute:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- lazyLoad --

- (HomePageTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[HomePageTableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        WS(weakSelf)
        _mainTableView.mj_header = [ETHomeRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.userDataCommand execute:nil];
            [weakSelf pageData:weakSelf.pageFlowView.currentPageIndex];
            /** 延迟1秒结束刷新 */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.mainTableView.mj_header endRefreshing];
            });
        }];
    }
    return _mainTableView;
}

- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        NSArray *titles = @[@"公众承诺",
                            @"今日PK",
                            @"PK记录",
                            @"动态"];
        // 注意: 一定要避免循环引用!!
        WS(weakSelf)
        _segmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, kNavHeight, ETScreenW, segmentViewHeight) segmentStyle:[[ZJSegmentStyle alloc] init] delegate:self titles:titles titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
            
        }];
        _segmentView.backgroundColor = ETGrayColor;
    }
    return _segmentView;
}

- (ZJContentView *)contentView {
    if (!_contentView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= optionHeight + kNavHeight;
        _contentView = [[ZJContentView alloc] initWithFrame:frame segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView.backgroundColor = ETClearColor;
    }
    return _contentView;
}

- (ETHomePageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETHomePageHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _headerView;
}

- (NewPagedFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 100)];
        _pageFlowView.scrollView.pagingEnabled = YES;
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
//        _pageFlowView.isCarousel = NO;
        _pageFlowView.minimumPageAlpha = 0;
        _pageFlowView.leftRightMargin = 30;
        _pageFlowView.topBottomMargin = 15;
        _pageFlowView.clickNumber = self.mainImageArray.count;
        _pageFlowView.orginPageCount = self.mainImageArray.count;
        _pageFlowView.isOpenAutoScroll = NO;
        _pageFlowView.isCarousel = NO;
    }
    return _pageFlowView;
}

- (NSMutableArray *)mainImageArray {
    if (!_mainImageArray) {
        _mainImageArray = [[NSMutableArray alloc] init];
        [_mainImageArray addObject:mine_promise_deep];
        [_mainImageArray addObject:mine_pk_deep];
        [_mainImageArray addObject:mine_pkRecord_deep];
        [_mainImageArray addObject:mine_log_deep];
    }
    return _mainImageArray;
}

- (NSMutableArray *)minorImageArray {
    if (!_minorImageArray) {
        _minorImageArray = [[NSMutableArray alloc] init];
        [_minorImageArray addObject:mine_promise_shallow];
        [_minorImageArray addObject:mine_pk_shallow];
        [_minorImageArray addObject:mine_pkRecord_shallow];
        [_minorImageArray addObject:mine_log_shallow];
    }
    return _minorImageArray;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = ETMinorBgColor;
        _topView.alpha = 0;
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ETTextColor_First;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"猜猜我是谁";
        _titleLabel.alpha = 0;
    }
    return _titleLabel;
}

//- (UIBarButtonItem *)pkReport {
//    if (!_pkReport) {
//        _pkReport = [[UIBarButtonItem alloc] initWithTitle:@"每日汇报" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
//        self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    }
//    return _pkReport;
//}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

- (ETHomePageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETHomePageViewModel alloc] initWithUserID:0];
    }
    return _viewModel;
}

#pragma mark -- private --

- (void)selectPhotos {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.isCoverImg ? @"设置PK封面" : @"设置头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
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
    UIImage *resultImage = [UIImage compressImage:image toKilobyte:self.isCoverImg ? 1024 : 500];
    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.5);
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    if (self.isCoverImg) {
        [self.viewModel.uploadCoverImgCommand execute:imageData];
    } else {
        [self.viewModel.uploadProfilePictureCommand execute:imageData];
    }
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.childScrollView && _childScrollView.contentOffset.y > 0) {
        self.mainTableView.contentOffset = CGPointMake(0.0f, headerViewHeight - kNavHeight);
        [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
        self.navigationController.navigationBar.tintColor = ETLightBlackColor;
        self.isTop = YES;
        [self preferredStatusBarStyle];
    } else {
        [self setupLeftNavBarWithimage:ETLeftArrow_White];
        self.isTop = NO;
        [self preferredStatusBarStyle];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0) {
        CGFloat alpha = offsetY / (headerViewHeight - kNavHeight);
        if (alpha >= 1) {
            alpha = 0.99;
        }
        self.topView.alpha = alpha;
        self.titleLabel.alpha = alpha;
    } else {
        self.topView.alpha = 0;
        self.titleLabel.alpha = 0;
    }
    
    if(offsetY < headerViewHeight - kNavHeight) {
        [self.viewModel.leaveFromTopSubject sendNext:nil];
    }
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    [self changePageWithIndex:index];
    [self pageData:index];
}


#pragma -- ZJScrollPageViewDelegate --
- (NSInteger)numberOfChildViewControllers {
    return 4;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(ETViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    ETViewController<ZJScrollPageViewChildVcDelegate> *childVC = reuseViewController;
    
    if (!childVC) {
        switch (index) {
            case 0: {
                childVC = [[ETHomePagePromiseVC alloc] initWithViewModel:self.viewModel];
            }
                break;
            case 1: {
                childVC = [[ETHomePagePKVC alloc] initWithViewModel:self.viewModel];
            }
                break;
            case 2: {
                childVC = [[ETHomePagePKRecordVC alloc] initWithViewModel:self.viewModel];
            }
                break;
            case 3: {
                childVC = [[ETHomePageLogVC alloc] initWithViewModel:self.viewModel];
            }
                break;
            default:
                break;
        }
        
    }
    return childVC;
}

#pragma mark -- NewPageDlowDelegate AND DataScoure --

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.mainImageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    PGIndexBannerSubiew *option = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!option) {
        option = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, ETScreenW * 0.34, ETScreenW * 0.18)];
        option.layer.cornerRadius = 10;
        option.layer.masksToBounds = YES;
    }
    option.backgroundColor = ETMinorBgColor;
    option.mainImage = [UIImage imageNamed:self.mainImageArray[index]];
    option.minorImage = [UIImage imageNamed:self.minorImageArray[index]];
    [option.mainImageView setImage:option.minorImage];
    option.mainImageView.contentMode = UIViewContentModeCenter;
    
    return option;
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(ETScreenW * 0.34, ETScreenW * 0.18);
}

- (void)didEndDeceleratingWithPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    [self changePageWithIndex:self.pageFlowView.currentPageIndex];
    [self.contentView setContentOffSet:CGPointMake(self.contentView.bounds.size.width * self.pageFlowView.currentPageIndex, 0.0) animated:YES];
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    [self changePageWithIndex:subIndex];
    [self.contentView setContentOffSet:CGPointMake(self.contentView.bounds.size.width * subIndex, 0.0) animated:YES];
}

- (void)changePageWithIndex:(NSInteger)index {
    [self.pageFlowView scrollToPage:index];
//    if (index == 1) {
//        self.navigationItem.rightBarButtonItem = self.pkReport;
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    for (NSInteger i = self.pageFlowView.visibleRange.location; i < self.pageFlowView.visibleRange.location + self.pageFlowView.visibleRange.length; i++) {
        PGIndexBannerSubiew *cell = [self.pageFlowView.cells objectAtIndex:i];
        if (i == index) {
            [self setOptionWithCell:cell Selected:YES];
        } else {
            [self setOptionWithCell:cell Selected:NO];
        }
    }
}

- (void)setOptionWithCell:(PGIndexBannerSubiew *)cell Selected:(BOOL)selected {
    if (selected) {
//        cell.backgroundColor = [UIColor colorWithHexString:@"FFBABA"];
        [cell.mainImageView setImage:cell.mainImage];
    } else {
//        cell.backgroundColor = ETWhiteColor;
        [cell.mainImageView setImage:cell.minorImage];
    }
}

#pragma mark -- delegate --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return optionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.pageFlowView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = ETClearColor;
    [cell.contentView addSubview:self.contentView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ETScreenH - optionHeight;
}

/** 为了正常显示子视图必须调用这个方法 */
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
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
