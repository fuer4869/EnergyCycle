//
//  ETPKProjectRankView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRankView.h"
#import "ETPKProjectViewModel.h"
#import "ETPKProjectRankHeaderView.h"
#import "ETPKProjectRankTableViewCell.h"

#import "ETRefreshGifHeader.h"

@interface ETPKProjectRankView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETPKProjectRankHeaderView *headerView;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKProjectRankView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.myReportDataCommand execute:nil];
    [self.viewModel.refreshRankDataCommand execute:nil];
    
    @weakify(self)
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.likeClickSubject subscribeNext:^(ETDailyPKProjectRankListModel *model) {
        @strongify(self)
        if ([model.Limit isEqualToString:@"1"]) {
            [self.viewModel.likeLimitOneCommand execute:model];
        } else {
            [self.viewModel.likeReportCommand execute:model.ReportID];
        }
        /** 点赞后要对数组中的数据进行更新,避免重用是显示出现错误 */
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ETDailyPKProjectRankListModel *listModel in self.viewModel.rankDataArray) {
            if ([listModel.ReportID isEqualToString:model.ReportID]) {
                listModel.Is_Like = [NSString stringWithFormat:@"%d", ![listModel.Is_Like boolValue]];
                NSInteger likes = [listModel.Likes integerValue] + ([listModel.Is_Like boolValue] ? 1 : (-1));
                listModel.Likes = [NSString stringWithFormat:@"%ld", (long)likes];
            }
            [array addObject:listModel];
        }
        self.viewModel.rankDataArray = array;
    }];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableHeaderView = self.headerView;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:NibName(ETPKProjectRankTableViewCell) forCellReuseIdentifier:ClassName(ETPKProjectRankTableViewCell)];
        
        WS(weakSelf)
//        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
//            [weakSelf.viewModel.refreshRankDataCommand execute:nil];
//        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.viewModel.nextPageRankCommand execute:nil];
        }];
    }
    return _mainTableView;
}

- (ETPKProjectRankHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETPKProjectRankHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _headerView;
}

- (ETPKProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.rankDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETPKProjectRankTableViewCell) forIndexPath:indexPath];
    cell.model = self.viewModel.rankDataArray[indexPath.row];
    cell.viewModel = self.viewModel;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
