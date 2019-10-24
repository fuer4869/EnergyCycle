//
//  ETOpinionView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETOpinionView.h"
#import "ETOpinionViewModel.h"
#import "ETOpinionHeaderView.h"
#import "ETLogPostListTableViewCell.h"
#import "ETHomeRefreshGifHeader.h"

#import "ETRemindView.h"

@interface ETOpinionView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETOpinionHeaderView *headerView;

@property (nonatomic, strong) ETOpinionViewModel *viewModel;

@end

@implementation ETOpinionView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETOpinionViewModel *)viewModel;
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
    [self.viewModel.firstEnterDataCommand execute:nil];

    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];

        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.postDeleteSubject subscribeNext:^(ETLogPostListTableViewCellViewModel *viewModel) {
        @strongify(self)
        [self.viewModel.postDeleteCommand execute:viewModel];
    }];
    
    [self.viewModel.postLikeSubject subscribeNext:^(NSString *postID) {
        @strongify(self)
        [self.viewModel.postLikeCommand execute:postID];
    }];
    
    [self.viewModel.firstEnterEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (![self.viewModel.firstEnterModel.Is_Suggest boolValue]) {
            if (@available(iOS 11.0, *)) {
                [ETRemindView remindImageName:@"remind_mine_opinion_X"];
            } else {
                [ETRemindView remindImageName:@"remind_mine_opinion"];
            }
            [self.viewModel.firstEnterUpdCommand execute:@"Is_Suggest"];
        }
    }];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMainBgColor;
        //        _mainTableView.backgroundColor = ETClearColor;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETLogPostListTableViewCell) forCellReuseIdentifier:ClassName(ETLogPostListTableViewCell)];
//        [_mainTableView registerNib:NibName(ETLogOutTableViewCell) forCellReuseIdentifier:ClassName(ETLogOutTableViewCell)];
        
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

- (ETOpinionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETOpinionHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _headerView;
}

- (ETOpinionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETOpinionViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
