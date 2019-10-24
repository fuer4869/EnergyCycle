//
//  ETUserInfoView.m
//  能量圈
//
//  Created by 王斌 on 2017/10/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUserInfoView.h"
#import "ETUserInfoViewModel.h"
#import "ETUserInfoTableViewCell.h"

@interface ETUserInfoView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIButton *shadowButton;

@property (nonatomic, strong) UIView *chooseView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) ETUserInfoViewModel *viewModel;

@end

@implementation ETUserInfoView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETUserInfoViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.userDataCommand execute:nil];
    
    [self.viewModel.refreshUserModelSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
    }];
}

- (void)setupPicker {
    [ETWindow addSubview:self.shadowButton];
    [self.shadowButton addSubview:self.chooseView];
    [self.shadowButton addSubview:self.datePicker];
    WS(weakSelf)
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.shadowButton);
        make.bottom.equalTo(weakSelf.shadowButton);
    }];
    
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.shadowButton);
        make.bottom.equalTo(weakSelf.datePicker.mas_top);
        make.height.equalTo(@50);
    }];
    
    UIButton *cancel = [[UIButton alloc] init];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancel setTitleColor:ETBlackColor forState:UIControlStateNormal];
    [self.chooseView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.chooseView);
        make.centerY.equalTo(weakSelf.chooseView);
        make.width.equalTo(@80);
    }];
    
    UIButton *sure = [[UIButton alloc] init];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sure setTitleColor:ETBlackColor forState:UIControlStateNormal];
    [self.chooseView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chooseView);
        make.centerY.equalTo(weakSelf.chooseView);
        make.width.equalTo(@80);
    }];
    
    @weakify(self)
    [[cancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self cancel];
    }];
    
    [[sure rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.model.Birthday = [self.datePicker.date jk_stringWithFormat:[NSDate jk_ymdFormat]];
        [self.mainTableView reloadData];
        [self cancel];
    }];
}

- (void)cancel {
    [self.shadowButton removeFromSuperview];
    [self.chooseView removeFromSuperview];
    [self.datePicker removeFromSuperview];
    [self.chooseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMinorBgColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETUserInfoTableViewCell) forCellReuseIdentifier:ClassName(ETUserInfoTableViewCell)];
    }
    return _mainTableView;
}

- (UIButton *)shadowButton {
    if (!_shadowButton) {
        _shadowButton = [[UIButton alloc] init];
        _shadowButton.frame = ETScreenB;
        _shadowButton.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.1];
        @weakify(self)
        [[_shadowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self cancel];
        }];
    }
    return _shadowButton;
}

- (UIView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[UIView alloc] init];
        _chooseView.backgroundColor = ETWhiteColor;
    }
    return _chooseView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = ETWhiteColor;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
//        [_datePicker addTarget:self action:@selector() forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (ETUserInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETUserInfoViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate and datasource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = ETMainBgColor;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETUserInfoTableViewCell *cell = [ETUserInfoTableViewCell tempTableViewCellWith:tableView indexPath:indexPath];
    cell.viewModel = self.viewModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 5 ? 190 : 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self setupPicker];
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
