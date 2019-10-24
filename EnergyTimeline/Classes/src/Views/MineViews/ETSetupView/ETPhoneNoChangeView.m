//
//  ETPhoneNoChangeView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPhoneNoChangeView.h"
#import "ETPhoneNoChangeViewModel.h"
#import "ETPhoneNoChangeTableViewCell.h"

@interface ETPhoneNoChangeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIButton *changeButton;

@property (nonatomic, strong) ETPhoneNoChangeViewModel *viewModel;

@end

@implementation ETPhoneNoChangeView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.bottom.equalTo(weakSelf).with.offset(IsiPhoneX ? -(10 + 34) : -10);
        make.height.equalTo(@60);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPhoneNoChangeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    [self addSubview:self.changeButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.hashCodeCommand execute:nil];
    
    [self.viewModel.validChangeSignal subscribeNext:^(id x) {
        @strongify(self)
        BOOL enabled = [x boolValue];
        self.changeButton.enabled = enabled;
        self.changeButton.backgroundColor = enabled ? ETMinorColor : ETMinorBgColor;
        [self.changeButton setTitleColor:enabled ? ETMinorBgColor : ETMinorColor forState:UIControlStateNormal];
    }];
    
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMainBgColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETPhoneNoChangeTableViewCell) forCellReuseIdentifier:ClassName(ETPhoneNoChangeTableViewCell)];
    }
    return _mainTableView;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [[UIButton alloc] init];
        [_changeButton setTitle:@"确认更换" forState:UIControlStateNormal];
        [_changeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _changeButton.layer.cornerRadius = 10;
        _changeButton.clipsToBounds = YES;
        @weakify(self)
        [[_changeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.phoneNoChangeCommand execute:nil];
        }];
    }
    return _changeButton;
}

- (ETPhoneNoChangeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPhoneNoChangeViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- ETPopViewDelegate --

//- (void)popViewClickSureBtn {
//    [self.mainTableView reloadData];
//}

#pragma mark -- tableview delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? 0.01 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETPhoneNoChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETPhoneNoChangeTableViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
