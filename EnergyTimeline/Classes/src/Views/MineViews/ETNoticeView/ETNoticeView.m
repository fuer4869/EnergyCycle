//
//  ETNoticeView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNoticeView.h"
#import "ETNoticeViewModel.h"
#import "ETNoticeTableViewCell.h"
#import "ETNoDataTableViewCell.h"

#import "ETRefreshGifHeader.h"

@interface ETNoticeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETNoticeViewModel *viewModel;

@end

@implementation ETNoticeView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETNoticeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.refreshDataCommand execute:nil];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView reloadData];
    }];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMainBgColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
        _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        [_mainTableView registerNib:NibName(ETNoticeTableViewCell) forCellReuseIdentifier:ClassName(ETNoticeTableViewCell)];
        [_mainTableView registerNib:NibName(ETNoDataTableViewCell) forCellReuseIdentifier:ClassName(ETNoDataTableViewCell)];
        
        WS(weakSelf)
        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
    }
    return _mainTableView;
}

- (ETNoticeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETNoticeViewModel alloc] init];
    }
    return _viewModel;
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
        ETNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETNoticeTableViewCell) forIndexPath:indexPath];
        cell.model = self.viewModel.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ETNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETNoDataTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.dataArray.count) {
        return [tableView fd_heightForCellWithIdentifier:ClassName(ETNoticeTableViewCell) cacheByIndexPath:indexPath configuration:^(ETNoticeTableViewCell *cell) {
            cell.fd_enforceFrameLayout = NO;
            cell.model = self.viewModel.dataArray[indexPath.row];
        }];
    }
    return self.mainTableView.jk_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
