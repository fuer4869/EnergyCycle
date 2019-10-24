//
//  ETHomePagePKView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePagePKView.h"
#import "ETHomePageViewModel.h"
#import "ETHomePagePKTableViewCell.h"
#import "ETNoDataTableViewCell.h"

@interface ETHomePagePKView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETHomePageViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ETHomePagePKView

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
//    [self.viewModel.refreshPKDataCommand execute:nil];
    
    [self.viewModel.refreshPKEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.leaveFromTopSubject subscribeNext:^(id x) {
        _scrollView.contentOffset = CGPointZero;
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
        [_mainTableView registerNib:NibName(ETHomePagePKTableViewCell) forCellReuseIdentifier:ClassName(ETHomePagePKTableViewCell)];
        [_mainTableView registerNib:NibName(ETNoDataTableViewCell) forCellReuseIdentifier:ClassName(ETNoDataTableViewCell)];
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
    return self.viewModel.pkDataArray.count ? self.viewModel.pkDataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.pkDataArray.count) {
        ETHomePagePKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETHomePagePKTableViewCell) forIndexPath:indexPath];
        cell.pkViewModel = self.viewModel.pkDataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    } else {
        ETNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETNoDataTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.pkDataArray.count ? 99 : self.mainTableView.jk_height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
