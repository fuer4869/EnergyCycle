//
//  ETAboutView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETAboutView.h"
#import "ETAboutViewModel.h"
#import "ETAboutHeaderView.h"
#import "ETAboutTableViewCell.h"

@interface ETAboutView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETAboutHeaderView *headerView;

@property (nonatomic, strong) ETAboutViewModel *viewModel;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation ETAboutView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).with.offset(IsiPhoneX ? -34.f : 0.f);
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETAboutViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    [self addSubview:self.bottomLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
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
        [_mainTableView registerNib:NibName(ETAboutTableViewCell) forCellReuseIdentifier:ClassName(ETAboutTableViewCell)];
    }
    return _mainTableView;
}

- (ETAboutHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:ClassName(ETAboutHeaderView) owner:nil options:nil].firstObject;
    }
    return _headerView;
}

- (ETAboutViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETAboutViewModel alloc] init];
    }
    return _viewModel;
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _webView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.text = @"上海摩英商务咨询有限公司 \n\n ©2015-2016 All Rights Reserved.";
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.font = [UIFont systemFontOfSize:9];
        _bottomLabel.textColor = ETTextColor_Third;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLabel;
}

#pragma mark -- delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [tableView deselectSectionCell:cell CornerRadius:10 forRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETAboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETAboutTableViewCell) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://400-800-6258"]]];
        }
            break;
        case 1: {
            NSString *scoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1079791492"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scoreUrl]];
        }
            break;
        case 2: {
            [self.viewModel.cellClickSubject sendNext:nil];
        }
            break;
        default:
            break;
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
