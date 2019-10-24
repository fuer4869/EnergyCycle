//
//  ETDailyPKView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKView.h"
#import "ETDailyPKViewModel.h"
#import "ETDailyPKTableViewCell.h"
#import "ETDailyPKHeaderView.h"
#import "ETDailyPKMineView.h"
#import "ETRefreshGifHeader.h"

@interface ETDailyPKView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETDailyPKViewModel *viewModel;

@property (nonatomic, strong) ETDailyPKHeaderView *headerView;

@property (nonatomic, strong) ETDailyPKMineView *mineView;

@end

@implementation ETDailyPKView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETDailyPKViewModel *)viewModel;
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
    [self.viewModel.mineCommand execute:nil];
    [self.viewModel.refreshDataCommand execute:nil];
    
    
    @weakify(self)
    [self.viewModel.refreshFirstEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.mineView.viewModel = self.viewModel.mineViewModel;
        self.headerView.viewModel = self.viewModel.headerViewModel;
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        // 如果有数据那么显示前三名
        if (self.viewModel.dataArray.count > 0) {
            CGFloat row = self.viewModel.dataArray.count >= 3 ? 2 : self.viewModel.dataArray.count - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        if (self.viewModel.headerViewModel.model.PKCoverImg) {
            [self.viewModel.refreshSubject sendNext:self.viewModel.headerViewModel.model.PKCoverImg];
        }
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.mineView.viewModel = self.viewModel.mineViewModel;
        self.headerView.viewModel = self.viewModel.headerViewModel;
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.likeClickSubject subscribeNext:^(NSString *reportID) {
        @strongify(self)
        [self.viewModel.likeReportCommand execute:reportID];
        /** 点赞后要对数组中的数据进行更新,避免重用是显示出现错误 */
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ETDailyPKTableViewCellViewModel *viewModel in self.viewModel.dataArray) {
            if ([viewModel.model.ReportID isEqualToString:reportID]) {
                viewModel.model.Is_Like = [NSString stringWithFormat:@"%d", ![viewModel.model.Is_Like boolValue]];
                NSInteger likes = [viewModel.model.Likes integerValue] + ([viewModel.model.Is_Like boolValue] ? 1 : (-1));
                viewModel.model.Likes = [NSString stringWithFormat:@"%ld", (long)likes];
            }
            [array addObject:viewModel];
        }
        self.viewModel.dataArray = array;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReportPKCompleted" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.mineCommand execute:nil];
        [self.viewModel.refreshDataCommand execute:nil];
    }];
}

#pragma mark -- lazyLoad --

- (ETDailyPKViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETDailyPKViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_mainTableView registerNib:NibName(ETDailyPKTableViewCell) forCellReuseIdentifier:ClassName(ETDailyPKTableViewCell)];
        
        WS(weakSelf)
        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.mineCommand execute:nil];
            [weakSelf.viewModel.refreshDataCommand execute:nil];
        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.viewModel.nextPageCommand execute:nil];
        }];
        
    }
    return _mainTableView;
}

- (ETDailyPKHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ETDailyPKHeaderView alloc] initWithViewModel:self.viewModel.headerViewModel];
        _headerView.frame = CGRectMake(0, 0, ETScreenW, ETScreenH - kNavHeight - 70);
        _headerView.viewModel.homePageSubject = self.viewModel.homePageSubject;
    }
    return _headerView;
}

- (ETDailyPKMineView *)mineView {
    if (!_mineView) {
        _mineView = [[ETDailyPKMineView alloc] initWithViewModel:self.viewModel.mineViewModel];
    }
    return _mineView;
}

#pragma mark -- delegate --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 70;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETDailyPKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETDailyPKTableViewCell) forIndexPath:indexPath];
    ETDailyPKTableViewCellViewModel *cellModel = self.viewModel.dataArray[indexPath.row];
    cellModel.indexPath = indexPath;
    if (indexPath.row == 0) {
        cell.type = ETDailyPKTableViewCellTypeTop;
    } else if (indexPath.row == 10 - 1) {
        cell.type = ETDailyPKTableViewCellTypeBottom;
    } else {
        cell.type = ETDailyPKTableViewCellTypeDefault;
    }
    cell.viewModel = cellModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.mineView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ETDailyPKTableViewCellViewModel *cellModel = self.viewModel.dataArray[indexPath.row];
    [self.viewModel.cellClickSubject sendNext:cellModel.model.UserID];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
