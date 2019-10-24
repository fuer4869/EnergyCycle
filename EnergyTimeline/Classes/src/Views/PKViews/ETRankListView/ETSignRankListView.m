//
//  ETSignRankListView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSignRankListView.h"
#import "ETSignRankListViewModel.h"
#import "ETSignRankHeaderView.h"
#import "ETSignRankListTableViewCell.h"

#import "ETRefreshGifHeader.h"

@interface ETSignRankListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETSignRankListViewModel *viewModel;

@property (nonatomic, strong) ETSignRankHeaderView *headerView;

@end

@implementation ETSignRankListView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETSignRankListViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    [self.viewModel.myCheckInCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
        self.headerView.viewModel = self.viewModel.headerViewModel;
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.likeClickSubject subscribeNext:^(NSString *userID) {
        @strongify(self)
        [self.viewModel.likeSignCommand execute:userID];
        /** 点赞后要对数组中的数据进行更新,避免重用是显示出现错误 */
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ETSignRankListTableViewCellViewModel *viewModel in self.viewModel.dataArray) {
            if ([viewModel.model.UserID isEqualToString:userID]) {
                viewModel.model.Is_Like = [NSString stringWithFormat:@"%d", ![viewModel.model.Is_Like boolValue]];
                NSInteger likes = [viewModel.model.Likes integerValue] + ([viewModel.model.Is_Like boolValue] ? 1 : (-1));
                viewModel.model.Likes = [NSString stringWithFormat:@"%ld", (long)likes];
            }
            [array addObject:viewModel];
        }
        self.viewModel.dataArray = array;
    }];
}

#pragma mark -- lazyLoad --

- (ETSignRankListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSignRankListViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.headerView;
        [_mainTableView registerNib:NibName(ETSignRankListTableViewCell) forCellReuseIdentifier:ClassName(ETSignRankListTableViewCell)];
        
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

- (ETSignRankHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETSignRankHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel.headerViewModel];
    }
    return _headerView;
}

#pragma mark -- delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETSignRankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETSignRankListTableViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
