//
//  ETFollowPostListView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETFollowPostListView.h"
#import "ETFollowPostListViewModel.h"
#import "ETNoDataTableViewCell.h"
#import "ETLogPostListTableViewCell.h"
#import "ETPromisePostListTableViewCell.h"
#import "ETHomeRefreshGifHeader.h"

@interface ETFollowPostListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ETFollowPostListViewModel *viewModel;

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation ETFollowPostListView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETFollowPostListViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark -- private -- 

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.refreshDataCommand execute:nil];
    
    [self.viewModel.backListTopSubject subscribeNext:^(id x) {
        @strongify(self)
        if (self.mainTableView.contentOffset.y <= 10) {
            [self.mainTableView.mj_header beginRefreshing];
        } else {
            [self.mainTableView setContentOffset:CGPointZero animated:YES];
        }
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.postLikeSubject subscribeNext:^(NSString *postID) {
        @strongify(self)
        [self.viewModel.postLikeCommand execute:postID];
    }];
}

#pragma mark -- lazyLoad --

- (ETFollowPostListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETFollowPostListViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMainBgColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
        [_mainTableView registerNib:NibName(ETNoDataTableViewCell) forCellReuseIdentifier:ClassName(ETNoDataTableViewCell)];
        [_mainTableView registerNib:NibName(ETLogPostListTableViewCell) forCellReuseIdentifier:ClassName(ETLogPostListTableViewCell)];
        [_mainTableView registerNib:NibName(ETPromisePostListTableViewCell) forCellReuseIdentifier:ClassName(ETPromisePostListTableViewCell)];
        
        WS(weakSelf)
        _mainTableView.mj_header = [ETHomeRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
    }
    return _mainTableView;
}

#pragma mark -- delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count ? self.viewModel.dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.dataArray.count) {
        PostModel *model = [self.viewModel.dataArray[indexPath.row] model].copy;
        if ([model.PostType integerValue] == 3) {
            ETPromisePostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETPromisePostListTableViewCell) forIndexPath:indexPath];
            cell.viewModel = self.viewModel.dataArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
        ETLogPostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETLogPostListTableViewCell) forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = NO;
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    } else {
        ETNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETNoDataTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.viewModel.dataArray.count) {
        return self.mainTableView.jk_height;
    }
    PostModel *model = [self.viewModel.dataArray[indexPath.row] model].copy;
    if ([model.PostType integerValue] == 3) {
        return 132;
    }
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
    if (self.viewModel.dataArray.count) {
        [self.viewModel.cellClickSubject sendNext:[self.viewModel.dataArray[indexPath.row] model]];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
