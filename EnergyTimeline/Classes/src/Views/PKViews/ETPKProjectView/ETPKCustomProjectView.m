//
//  ETPKCustomProjectView.m
//  能量圈
//
//  Created by 王斌 on 2018/2/2.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKCustomProjectView.h"
#import "ETPKProjectViewModel.h"
#import "ETPKProjectRecordHeaderView.h"
#import "ETPKProjectRecordTableViewCell.h"

#import "ETRefreshGifHeader.h"

#import "ETPKReportPopView.h"

@interface ETPKCustomProjectView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETPKProjectRecordHeaderView *headerView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *reportButton;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKCustomProjectView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@60);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.bottomView);
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
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.reportButton];
    
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
    
    [[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        ETPKReportPopView *pkReportPopView = [[ETPKReportPopView alloc] initWithFrame:ETScreenB];
        pkReportPopView.model = self.viewModel.model;
        [pkReportPopView.viewModel.reportCompletedSubject subscribeNext:^(id x) {
            [self.viewModel.myReportDataCommand execute:nil];
            [self.viewModel.refreshRankDataCommand execute:nil];
            [self.viewModel.refreshRecordDataCommand execute:nil];
        }];
        [ETWindow addSubview:pkReportPopView];
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
        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.refreshRecordDataCommand execute:nil];
        }];
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = ETMinorBgColor;
    }
    return _bottomView;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        [_reportButton setImage:[UIImage imageNamed:@"pk_clockIn_tabular_yellow"] forState:UIControlStateNormal];
    }
    return _reportButton;
}

- (ETPKProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate --

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.bottomView.alpha = 0;
//    self.reportButton.alpha = 0;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    self.reportButton.alpha = 0;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.reportButton.alpha = 1;
    self.bottomView.alpha = 1;

}

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
