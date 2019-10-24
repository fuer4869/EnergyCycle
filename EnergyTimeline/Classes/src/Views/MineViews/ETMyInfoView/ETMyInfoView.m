//
//  ETMyInfoView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMyInfoView.h"
#import "ETMyInfoViewModel.h"
#import "ETMyInfoTableViewCell.h"

@interface ETMyInfoView () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIButton *shadowButton;

@property (nonatomic, strong) UIView *chooseView;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) ETMyInfoViewModel *viewModel;

@end

@implementation ETMyInfoView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETMyInfoViewModel *)viewModel;
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
    
    [self.viewModel.cancelSubject subscribeNext:^(id x) {
        @strongify(self)
        [self cancel];
    }];
}

- (void)setupPickerWithRow:(NSInteger)row {
    [ETWindow addSubview:self.shadowButton];
    [self.shadowButton addSubview:self.chooseView];
    if (row == 2) {
        [self.shadowButton addSubview:self.pickerView];
        WS(weakSelf)
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.shadowButton);
        }];
        
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.shadowButton);
            make.bottom.equalTo(weakSelf.pickerView.mas_top);
            make.height.equalTo(@50);
        }];
    } else if (row == 3) {
        [self.shadowButton addSubview:self.datePicker];
        WS(weakSelf)
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.shadowButton);
        }];
        
        [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf.shadowButton);
            make.bottom.equalTo(weakSelf.datePicker.mas_top);
            make.height.equalTo(@50);
        }];
    }
    
    UIButton *cancel = [[UIButton alloc] init];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancel setTitleColor:ETBlackColor forState:UIControlStateNormal];
    [self.chooseView addSubview:cancel];
    WS(weakSelf)
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
        if (row == 2) {
            self.viewModel.infoModel.model.Gender = [self.pickerView selectedRowInComponent:0] ? @"2" : @"1";
        } else if (row == 3) {
            self.viewModel.infoModel.model.Birthday = [self.datePicker.date jk_formatYMD];
        }
        [self.mainTableView reloadData];
        [self cancel];
    }];
}

- (void)datePickerValueChange:(UIDatePicker *)picker {
}

- (void)cancel {
    [self.shadowButton removeFromSuperview];
    [self.chooseView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.datePicker removeFromSuperview];
    [self.chooseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMainBgColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETMyInfoTableViewCell) forCellReuseIdentifier:ClassName(ETMyInfoTableViewCell)];
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

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = ETWhiteColor;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = ETWhiteColor;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
        [_datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (ETMyInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMyInfoViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- UIPickerViewDelegate UIPickerViewDataSource --

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row ? @"女" : @"男";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark -- UITableViewDelegate UITableViewDataSource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [tableView deselectSectionCell:cell CornerRadius:10 forRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETMyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETMyInfoTableViewCell) forIndexPath:indexPath];
    self.viewModel.infoModel.indexPath = indexPath;
    cell.viewModel = self.viewModel.infoModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 3) {
        [self setupPickerWithRow:indexPath.row];
    } else {
        self.viewModel.infoModel.indexPath = indexPath;
        [self.viewModel.cellClickSubject sendNext:self.viewModel.infoModel];
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
