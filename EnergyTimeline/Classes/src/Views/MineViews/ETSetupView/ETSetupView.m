//
//  ETSetupView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSetupView.h"
#import "ETSetupViewModel.h"
#import "ETSetupTableViewCell.h"
#import "ETLogOutTableViewCell.h"

#import "ETPopView.h"
#import "CacheManager.h"

@interface ETSetupView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETSetupViewModel *viewModel;

@end

@implementation ETSetupView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETSetupViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMinorBgColor;
//        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETSetupTableViewCell) forCellReuseIdentifier:ClassName(ETSetupTableViewCell)];
        [_mainTableView registerNib:NibName(ETLogOutTableViewCell) forCellReuseIdentifier:ClassName(ETLogOutTableViewCell)];
    }
    return _mainTableView;
}

- (ETSetupViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSetupViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- tableview delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? 1 : 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    if (!section) {
        header.backgroundColor = ETMainBgColor;
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? 13 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        ETLogOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETLogOutTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    ETSetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETSetupTableViewCell) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section ? 55 : 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        switch (indexPath.row) {
            case 4: {
                [ETPopView popViewWithTip:@"要开启或关闭能量圈的推送通知,请在iPhone的“设置”-“通知”中找到“能量圈”进行设置"];
            }
                break;
            default: {
                [self.viewModel.cellClickSubject sendNext:indexPath];
            }
                break;
        }
    } else {
        [self.viewModel.cellClickSubject sendNext:indexPath];
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
