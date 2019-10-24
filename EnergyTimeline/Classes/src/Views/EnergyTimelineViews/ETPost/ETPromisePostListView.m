//
//  ETPromisePostListView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPromisePostListView.h"
#import "ETPromisePostListViewModel.h"
#import "ETPromisePostListHeaderView.h"
#import "ETPromisePostListTableViewCell.h"
#import "ETNoDataTableViewCell.h"

#import "ETHomeRefreshGifHeader.h"

@interface ETPromisePostListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ETPromisePostListViewModel *viewModel;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETPromisePostListHeaderView *headerView;

//@property (strong, nonatomic) 

@end

@implementation ETPromisePostListView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPromisePostListViewModel *)viewModel;
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
    [self setNeedsUpdateConstraints]; // 将view标记为需要更新的约束
    [self updateConstraintsIfNeeded]; // 更新view的约束
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self)
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
        if (!self.viewModel.headerViewModel.dataArray.count) {
            self.headerView.jk_height = 5;
        } else {
            self.headerView.jk_height = 80;
        }
        self.mainTableView.tableHeaderView = self.headerView;
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

- (ETPromisePostListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPromisePostListViewModel alloc] init];
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
        _mainTableView.tableHeaderView = self.headerView;
        [_mainTableView registerNib:NibName(ETPromisePostListTableViewCell) forCellReuseIdentifier:ClassName(ETPromisePostListTableViewCell)];
        [_mainTableView registerNib:NibName(ETNoDataTableViewCell) forCellReuseIdentifier:ClassName(ETNoDataTableViewCell)];

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

- (ETPromisePostListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ETPromisePostListHeaderView alloc] initWithViewModel:self.viewModel.headerViewModel];
        _headerView.frame = CGRectMake(0, 0, ETScreenW, 80);
    }
    return _headerView;
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
        ETPromisePostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETPromisePostListTableViewCell) forIndexPath:indexPath];
        cell.viewModel = self.viewModel.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ETNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETNoDataTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.dataArray.count ? 132 : self.mainTableView.jk_height;
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
