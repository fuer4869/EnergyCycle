//
//  ETTrainTargetHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainTargetHeaderView.h"
#import "ETTrainTargetViewModel.h"

static NSString * const pk_train_up_arrows_red = @"pk_train_up_arrows_red";

@interface ETTrainTargetHeaderView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) ETTrainTargetViewModel *viewModel;

@end

@implementation ETTrainTargetHeaderView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@30);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.height.equalTo(weakSelf.mas_width);
        make.width.equalTo(@70);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETTrainTargetViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.topLabel];
    [self addSubview:self.pickerView];
    [self addSubview:self.selectImageView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
//        self.viewModel.trainTarget = self.viewModel.trainArray[self.viewModel.trainRow];
        [self.pickerView reloadAllComponents];
    }];
}

#pragma mark -- lazyLoad --

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _topLabel.textColor = ETTextColor_Fourth;
        _topLabel.text = @"今日目标";
    }
    return _topLabel;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        // 旋转让选择器变成横向滑动
        _pickerView.transform = CGAffineTransformMakeRotation(M_PI * 3 / 2);
    }
    return _pickerView;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        [_selectImageView setImage:[UIImage imageNamed:pk_train_up_arrows_red]];
    }
    return _selectImageView;
}

- (ETTrainTargetViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainTargetViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- UIPickerViewDelegate --

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.viewModel.trainTarget = self.viewModel.trainArray[row];
}

#pragma mark -- UIPickerViewDataSource --

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.viewModel.trainArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 80;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = ETClearColor;
        }
    }
    UILabel *pickerLabel = [[UILabel alloc] init];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = ETMinorBgColor;
    pickerLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightSemibold];
    pickerLabel.text = self.viewModel.trainArray[row];
    pickerLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    return pickerLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
