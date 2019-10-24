//
//  ETNewFansListView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNewFansListView.h"
#import "ETNewFansListViewModel.h"
#import "ETUserTableViewCell.h"
#import "ETNoDataTableViewCell.h"

#import "ETRefreshGifHeader.h"

@interface ETNewFansListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETNewFansListViewModel *viewModel;

@end

@implementation ETNewFansListView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETNewFansListViewModel *)viewModel;
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
        [_mainTableView registerNib:NibName(ETUserTableViewCell) forCellReuseIdentifier:ClassName(ETUserTableViewCell)];
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

- (ETNewFansListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETNewFansListViewModel alloc] init];
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

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!indexPath.section) {
//        [tableView deselectSectionCell:cell CornerRadius:10 forRowAtIndexPath:indexPath];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.dataArray.count) {
        ETUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETUserTableViewCell) forIndexPath:indexPath];
        cell.novelFansListViewModel = self.viewModel.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ETNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETNoDataTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.dataArray.count ? 75 : self.mainTableView.jk_height;;
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
