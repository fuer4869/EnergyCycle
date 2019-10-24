//
//  ETFansListView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETFansListView.h"
#import "ETFansListViewModel.h"
#import "ETUserTableViewCell.h"

#import "ETRefreshGifHeader.h"

@interface ETFansListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETFansListViewModel *viewModel;

@end

@implementation ETFansListView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETFansListViewModel *)viewModel;
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
        [self.mainTableView reloadData];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.attentionSubject subscribeNext:^(NSString *userID) {
        @strongify(self)
        [self.viewModel.attentionCommand execute:userID];
        /** 关注后要对数组中的数据进行更新,避免重用是显示出现错误 */
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ETNewFansListTableViewCellViewModel *viewModel in self.viewModel.dataArray) {
            if ([viewModel.model.UserID isEqualToString:userID]) {
                viewModel.model.Is_Attention = [NSString stringWithFormat:@"%d", ![viewModel.model.Is_Attention boolValue]];
            }
            [array addObject:viewModel];
        }
        self.viewModel.dataArray = array;
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
        _mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:NibName(ETUserTableViewCell) forCellReuseIdentifier:ClassName(ETUserTableViewCell)];
        
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

- (ETFansListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETFansListViewModel alloc] init];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [tableView deselectSectionCell:cell CornerRadius:10 forRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETUserTableViewCell) forIndexPath:indexPath];
    cell.fansListViewModel = self.viewModel.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.cellClickSubject sendNext:indexPath];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
