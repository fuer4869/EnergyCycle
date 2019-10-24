//
//  ETHomePagePromiseView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePagePromiseView.h"
#import "ETHomePageViewModel.h"
#import "ETHomePagePromiseTableViewCell.h"
#import "ETNoDataTableViewCell.h"

@interface ETHomePagePromiseView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETHomePageViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ETHomePagePromiseView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETHomePageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
//    [self.viewModel.refreshPromiseDataCommand execute:nil];
    
    [self.viewModel.refreshPromiseEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
    [self.viewModel.leaveFromTopSubject subscribeNext:^(id x) {
        _scrollView.contentOffset = CGPointZero;
    }];
    
    [self.viewModel.postLikeSubject subscribeNext:^(NSString *postID) {
        @strongify(self)
        [self.viewModel.postLikeCommand execute:postID];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = scrollView;
    }
    [self.viewModel.scrollViewSubject sendNext:scrollView];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:NibName(ETHomePagePromiseTableViewCell) forCellReuseIdentifier:ClassName(ETHomePagePromiseTableViewCell)];
        [_mainTableView registerNib:NibName(ETNoDataTableViewCell) forCellReuseIdentifier:ClassName(ETNoDataTableViewCell)];
        
        WS(weakSelf)
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.viewModel.nextPromisePageCommand execute:nil];
        }];
    }
    return _mainTableView;
}

- (ETHomePageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETHomePageViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.promiseDataArray.count ? self.viewModel.promiseDataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.promiseDataArray.count) {
        ETHomePagePromiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETHomePagePromiseTableViewCell) forIndexPath:indexPath];
        cell.viewModel = self.viewModel.promiseDataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    } else {
        ETNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETNoDataTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.promiseDataArray.count ? 135 : self.mainTableView.jk_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.promiseDataArray.count) {
        [self.viewModel.cellClickSubject sendNext:[self.viewModel.promiseDataArray[indexPath.row] model]];
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
