//
//  ETFindView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETFindView.h"
#import "ETFindViewModel.h"
#import "ETBannerCollectionViewCell.h"
#import "ETLogPostListTableViewCell.h"
#import "ETRefreshGifHeader.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "ETRadioMiniView.h"

@interface ETFindView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UISearchController *search;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *searchView;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) ETRadioMiniView *radioMiniView;

@property (nonatomic, strong) ETFindViewModel *viewModel;

@end

@implementation ETFindView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETFindViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
//        make.top.equalTo(@kNavHeight);
//        make.left.right.bottom.equalTo(weakSelf);
    }];
    
//    [self.search.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf).with.offset(20);
//    }];
    
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(weakSelf);
//        make.height.equalTo(@(kNavHeight));
//    }];
//
//    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf).with.offset(8 + kStatusBarHeight);
//        make.left.equalTo(weakSelf).with.offset(30);
//        make.right.equalTo(weakSelf).with.offset(-30);
//        make.height.equalTo(@26);
//    }];
    
    [self.pageFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.headerView);
        make.height.equalTo(@200);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.pageFlowView);
        make.height.equalTo(@8);
        make.centerX.equalTo(weakSelf.pageFlowView);
        make.bottom.equalTo(weakSelf.pageFlowView).with.equalTo(-8);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pageFlowView.mas_bottom);
        make.left.right.equalTo(weakSelf.headerView);
        make.height.equalTo(65);
    }];
    
    [self.radioMiniView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionView.mas_bottom);
        make.left.right.equalTo(weakSelf.headerView);
        make.height.equalTo(@90);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    [self.headerView addSubview:self.pageFlowView];
//    [self.headerView addSubview:self.search.searchBar];
    [self.headerView addSubview:self.collectionView];
    [self.headerView addSubview:self.radioMiniView];
//    [self addSubview:self.topView];
//    [self addSubview:self.searchView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.refreshDataCommand execute:nil];
    [self.viewModel.bannerCommand execute:nil];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.pageFlowView reloadData];
        [self.collectionView reloadData];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.postLikeSubject subscribeNext:^(NSString *postID) {
        @strongify(self)
        [self.viewModel.postLikeCommand execute:postID];
    }];
    
    [self.viewModel.postDeleteSubject subscribeNext:^(ETLogPostListTableViewCellViewModel *viewModel) {
        @strongify(self)
        [self.viewModel.postDeleteCommand execute:viewModel];
    }];
}


#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mainTableView.tableHeaderView = self.headerView;
        [_mainTableView registerNib:NibName(ETLogPostListTableViewCell) forCellReuseIdentifier:ClassName(ETLogPostListTableViewCell)];
        
        WS(weakSelf)
        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.refreshDataCommand execute:nil];
            [weakSelf.viewModel.bannerCommand execute:nil];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
    }
    return _mainTableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = ETClearColor;
        _headerView.frame = CGRectMake(0, 0, ETScreenW, 355);
    }
    return _headerView;
}

//- (UISearchController *)search {
//    if (!_search) {
//        _search = [[UISearchController alloc] initWithSearchResultsController:self.searchVC];
//        _search.searchResultsUpdater = self.searchVC;
//        _search.delegate = self.searchVC;
//        _search.hidesNavigationBarDuringPresentation = NO;
//    }
//    return _search;
//}

- (NewPagedFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] init];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0;
        _pageFlowView.orginPageCount = self.viewModel.topBannerArray.count;
        _pageFlowView.pageControl = self.pageControl;
        [_pageFlowView addSubview:self.pageControl];
    }
    return _pageFlowView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETClearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETBannerCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETBannerCollectionViewCell)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (ETRadioMiniView *)radioMiniView {
    if (!_radioMiniView) {
        _radioMiniView = [[ETRadioMiniView alloc] initWithViewModel:self.viewModel.radioViewModel];
    }
    return _radioMiniView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = ETMainBgColor;
        _topView.alpha = 0;
    }
    return _topView;
}

- (UIButton *)searchView {
    if (!_searchView) {
        _searchView = [[UIButton alloc] init];
        _searchView.backgroundColor = [ETGrayColor colorWithAlphaComponent:0.3];
        _searchView.layer.cornerRadius = 13;
        _searchView.layer.masksToBounds = YES;
        [_searchView.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_searchView setTitle:@"搜索 用户/动态" forState:UIControlStateNormal];
        [_searchView setTitleColor:ETLightBlackColor forState:UIControlStateNormal];
        [_searchView setImage:[UIImage imageNamed:@"search_gray"] forState:UIControlStateNormal];
        [[_searchView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.viewModel.searchSubject sendNext:nil];
        }];
    }
    return _searchView;
}

#pragma mark -- UIScrollViewDelegate --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0) {
        CGFloat alpha = offsetY / (360 - kNavHeight);
        if (alpha >= 1) {
            alpha = 0.99;
        }
        self.topView.alpha = alpha;
    } else {
        self.topView.alpha = 0;
    }
}

#pragma mark -- tableViewDelegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 20)];
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor colorWithHexString:@"FFE10C"];
    [headerSectionView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerSectionView).with.offset(20);
        make.centerY.equalTo(headerSectionView);
        make.width.equalTo(@3);
        make.height.equalTo(@12);
    }];
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"精彩推荐";
    rightLabel.textColor = ETTextColor_First;
    [rightLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [headerSectionView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).with.offset(5);
        make.centerY.equalTo(headerSectionView);
    }];
    return headerSectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETLogPostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETLogPostListTableViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:ClassName(ETLogPostListTableViewCell) configuration:^(ETLogPostListTableViewCell *cell) {
//        cell.fd_enforceFrameLayout = NO;
//        cell.viewModel = self.viewModel.dataArray[indexPath.row];
//    }];
    return [tableView fd_heightForCellWithIdentifier:ClassName(ETLogPostListTableViewCell) cacheByIndexPath:indexPath configuration:^(ETLogPostListTableViewCell *cell) {
        cell.fd_enforceFrameLayout = NO;
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.cellClickSubject sendNext:[self.viewModel.dataArray[indexPath.row] model]];
}

#pragma mark -- newPageFlowDelegate and datascoure --

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.viewModel.topBannerArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    PGIndexBannerSubiew *banner = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!banner) {
        banner = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 200)];
        banner.layer.masksToBounds = YES;
    }
    [banner.mainImageView sd_setImageWithURL:[NSURL URLWithString:[self.viewModel.topBannerArray[index] FilePath]]];
    return banner;
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(ETScreenW, 200);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    [self.viewModel.topBannerCellClickSubjet sendNext:self.viewModel.topBannerArray[subIndex]];
}

#pragma mark -- collectionViewDelegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.bottomBannerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETBannerCollectionViewCell) forIndexPath:indexPath];
    cell.model = self.viewModel.bottomBannerArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 45);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.bottomBannerCellClickSubject sendNext:self.viewModel.bottomBannerArray[indexPath.row]];
}

//- (UICollectionView *)collectionView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
