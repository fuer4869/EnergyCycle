//
//  ETPKProjectRecordView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRecordView.h"
#import "ETPKProjectViewModel.h"
#import "ETPKProjectRecordHeaderView.h"
#import "ETPKProjectRecordTableViewCell.h"

#import "ETRefreshGifHeader.h"

@interface ETPKProjectRecordView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETPKProjectRecordHeaderView *headerView;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKProjectRecordView

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
    [self.viewModel.refreshRecordDataCommand execute:nil];
    
    @weakify(self)
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
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
        [_mainTableView registerNib:NibName(ETPKProjectRecordTableViewCell) forCellReuseIdentifier:ClassName(ETPKProjectRecordTableViewCell)];
        
        WS(weakSelf)
//        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
//            [weakSelf.viewModel.refreshRecordDataCommand execute:nil];
//        }];
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.viewModel.nextPageRecordDataCommand execute:nil];
        }];
    }
    return _mainTableView;
}

- (ETPKProjectRecordHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETPKProjectRecordHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
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
    return self.viewModel.recordDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETPKProjectRecordTableViewCell) forIndexPath:indexPath];
    cell.model = self.viewModel.recordDataArray[indexPath.row];
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
