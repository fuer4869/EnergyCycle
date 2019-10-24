//
//  ETIntergralRankView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralRankView.h"
#import "ETIntegralRankViewModel.h"
#import "ETIntegralRankHeaderView.h"
#import "ETIntegralRankFooterView.h"
#import "ETRankTableViewCell.h"
#import "ETRefreshGifHeader.h"

@interface ETIntegralRankView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETIntegralRankHeaderView *headerView;

@property (nonatomic, strong) ETIntegralRankFooterView *footerView;

@property (nonatomic, strong) ETIntegralRankViewModel *viewModel;

@property (nonatomic, strong) UIView *headerSectionView;

@property (nonatomic, strong) UILabel *contentLabel;

//@property (nonatomic, strong)

@end

@implementation ETIntegralRankView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf);
        make.left.right.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).with.offset(-(48 + kSafeAreaBottomHeight));
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@(48 + kSafeAreaBottomHeight));
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETIntegralRankViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    [self addSubview:self.footerView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.refreshDataCommand execute:nil];
    [self.viewModel.refreshFriendDataCommand execute:nil];
    [self.viewModel.myIntegralDataCommand execute:nil];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.currentSegment) {
            self.contentLabel.text = [self.viewModel.model.FriendRanking integerValue] == 1 ? [NSString stringWithFormat:@"您战胜了%@个好友", self.viewModel.model.FriendExceedNum] : [NSString stringWithFormat:@"您战胜了%@个好友(您还差%@分可以超越%@)", self.viewModel.model.FriendExceedNum, self.viewModel.model.FriendDiffIntegral, self.viewModel.model.PreFriendName];
        } else {
            self.contentLabel.text = [self.viewModel.model.Ranking integerValue] == 1 ? [NSString stringWithFormat:@"您战胜了%@个对手", self.viewModel.model.WorldExceedNum] : [NSString stringWithFormat:@"您战胜了%@个对手(您还差%@分可以超越第%ld名)", self.viewModel.model.WorldExceedNum, self.viewModel.model.WorldDiffIntegral, (long)([self.viewModel.model.Ranking integerValue] - 1)];
        }
//        self.contentLabel.text = self.viewModel.currentSegment ? [NSString stringWithFormat:@"您战胜了%@个好友(您还差%@分可以超越%@)", self.viewModel.model.FriendExceedNum, self.viewModel.model.FriendDiffIntegral, self.viewModel.model.PreFriendName] : [NSString stringWithFormat:@"您战胜了%@个对手(您还差%@分可以超越第%ld名)", self.viewModel.model.WorldExceedNum, self.viewModel.model.WorldDiffIntegral, (long)([self.viewModel.model.Ranking integerValue] - 1)];

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
        [_mainTableView registerNib:NibName(ETRankTableViewCell) forCellReuseIdentifier:ClassName(ETRankTableViewCell)];
        
        WS(weakSelf)
        _mainTableView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
            if (!weakSelf.viewModel.currentSegment) {
                [weakSelf.viewModel.refreshDataCommand execute:nil];
            } else {
                [weakSelf.viewModel.refreshFriendDataCommand execute:nil];
            }
        }];
        
        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (!weakSelf.viewModel.currentSegment) {
                [weakSelf.viewModel.nextPageCommand execute:nil];
            } else {
                [weakSelf.viewModel.nextFriendPageCommand execute:nil];
            }
        }];
    }
    return _mainTableView;
}

- (ETIntegralRankHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETIntegralRankHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _headerView;
}

- (ETIntegralRankFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETIntegralRankFooterView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _footerView;
}

- (UIView *)headerSectionView {
    if (!_headerSectionView) {
        _headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 20)];
        [_headerSectionView addSubview:self.contentLabel];
        WS(weakSelf)
        [weakSelf.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.top.bottom.equalTo(_headerSectionView);
        }];
    }
    return _headerSectionView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"您战胜了--个对手(您还差--分可以超越第--名)";
        _contentLabel.font = [UIFont systemFontOfSize:10];
        _contentLabel.textColor = ETTextColor_Third;
        _contentLabel.backgroundColor = ETMainLineColor;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (ETIntegralRankViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETIntegralRankViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 155 && !self.viewModel.slideBottom) {
        self.contentLabel.backgroundColor = ETMainBgColor;
        self.contentLabel.font = [UIFont systemFontOfSize:11];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@14);
        }];
    } else if (scrollView.contentOffset.y < 155 && self.viewModel.slideBottom) {
        self.contentLabel.backgroundColor = ETMainLineColor;
        self.contentLabel.font = [UIFont systemFontOfSize:10];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.bottom.equalTo(@0);
        }];
    }
    [self.viewModel.refreshScrollSubject sendNext:scrollView];

//    NSLog(@"%e", self.mainTableView.contentOffset.y);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.currentSegment ? self.viewModel.friendDataArray.count : self.viewModel.worldDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerSectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETRankTableViewCell) forIndexPath:indexPath];
    if (!self.viewModel.currentSegment) {
        cell.integralRankViewModel = self.viewModel.worldDataArray[indexPath.row];
    } else {
        cell.integralRankViewModel = self.viewModel.friendDataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.viewModel.currentSegment) {
        [self.viewModel.cellClickSubject sendNext:[self.viewModel.worldDataArray[indexPath.row] model]];
    } else {
        [self.viewModel.cellClickSubject sendNext:[self.viewModel.friendDataArray[indexPath.row] model]];
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
