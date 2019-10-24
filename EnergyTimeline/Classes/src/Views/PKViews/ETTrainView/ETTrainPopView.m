//
//  ETTrainPopView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainPopView.h"

static NSString * const pk_train_left_arrows_red = @"pk_train_left_arrows_red";
static NSString * const pk_train_right_arrows_red = @"pk_train_right_arrows_red";

@interface ETTrainPopView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *topLeftLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIPickerView *contentPicker;

@property (nonatomic, strong) UIButton *leftCenterButton;

@property (nonatomic, strong) UIButton *rightCenterButton;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *selectData;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation ETTrainPopView

- (instancetype)init {
    if (self = [super initWithFrame:ETScreenB]) {
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@35);
        make.right.equalTo(@-35);
        make.centerY.equalTo(weakSelf.shadowView);
//        make.centerY.equalTo(weakSelf.shadowView).with.offset(-30);
        make.height.equalTo(@(230));
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@60);
    }];
    
    [self.topLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(15);
        make.centerY.equalTo(weakSelf.topLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(30);
        make.right.equalTo(weakSelf.contentView).with.offset(-30);
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.bottom.equalTo(weakSelf.leftButton.mas_top);
    }];
    
    /** 为了实现横向显示UIPickerView,这里把view倾斜了90度,所以设置宽和高时需要将这两者调换 */
    [self.contentPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.contentView.mas_width);
        make.width.equalTo(@110);
//        make.left.right.equalTo(weakSelf.contentView);
//        make.top.equalTo(weakSelf.lineView.mas_bottom);
//        make.bottom.equalTo(weakSelf.leftButton.mas_top);
    }];
    
    [self.leftCenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.contentLabel);
        make.left.equalTo(weakSelf.contentView);
        make.width.equalTo(@70);
    }];
    
    [self.rightCenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.contentLabel);
        make.right.equalTo(weakSelf.contentView);
        make.width.equalTo(@70);
    }];
    
    [@[self.leftButton, self.rightButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[self.leftButton, self.rightButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(@60);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithTitle:(NSString *)title Content:(NSString *)content LeftBtnTitle:(NSString *)leftBtnTitle RightBtnTitle:(NSString *)rightBtnTitle {
    ETTrainPopView *popView = [[ETTrainPopView alloc] init];
    popView.topLabel.text = title;
    popView.contentLabel.text = content;
    [popView.leftButton setTitle:leftBtnTitle forState:UIControlStateNormal];
    [popView.rightButton setTitle:rightBtnTitle forState:UIControlStateNormal];
    return popView;
}

- (instancetype)initWithTitle:(NSString *)title ContentArray:(NSArray *)contentArray LeftBtnTitle:(NSString *)leftBtnTitle RightBtnTitle:(NSString *)rightBtnTitle {
    ETTrainPopView *popView = [[ETTrainPopView alloc] init];
    popView.topLeftLabel.text = title;
    popView.dataArray = contentArray;
    popView.selectIndex = 0;
    popView.selectData = contentArray[0];
    popView.topLabel.hidden = YES;
    popView.contentLabel.hidden = YES;
    popView.topLeftLabel.hidden = NO;
    popView.contentPicker.hidden = NO;
    popView.leftCenterButton.hidden = NO;
    popView.rightCenterButton.hidden = NO;
    [popView.leftButton setTitle:leftBtnTitle forState:UIControlStateNormal];
    [popView.rightButton setTitle:rightBtnTitle forState:UIControlStateNormal];
    return popView;
}

- (void)et_setupViews {
    [self addSubview:self.shadowView];
    [self.shadowView addSubview:self.contentView];
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.topLeftLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.contentPicker];
    [self.contentView addSubview:self.leftCenterButton];
    [self.contentView addSubview:self.rightCenterButton];
    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.rightButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [[self.leftCenterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.selectIndex == 0) {
            self.selectIndex = self.dataArray.count - 1;
        } else {
            self.selectIndex --;
        }
        self.selectData = self.dataArray[self.selectIndex];
        [self.contentPicker selectRow:self.selectIndex inComponent:0 animated:NO];
        [self.contentPicker reloadAllComponents];
    }];
    
    [[self.rightCenterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.selectIndex == self.dataArray.count - 1) {
            self.selectIndex = 0;
        } else {
            self.selectIndex ++;
        }
        self.selectData = self.dataArray[self.selectIndex];
        [self.contentPicker selectRow:self.selectIndex inComponent:0 animated:NO];
        [self.contentPicker reloadAllComponents];
    }];
    
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(leftButtonClick:)]) {
            [self.delegate leftButtonClick:self.selectData];
        }
        [self removeFromSuperview];
    }];
    
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(rightButtonClick:)]) {
            [self.delegate rightButtonClick:self.selectData];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark -- lazyLoad --

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.4];
    }
    return _shadowView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ETWhiteColor;
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _topLabel.textColor = ETTextColor_Sixth;
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.text = @"提示";
    }
    return _topLabel;
}

- (UILabel *)topLeftLabel {
    if (!_topLeftLabel) {
        _topLeftLabel = [[UILabel alloc] init];
        _topLeftLabel.font = [UIFont systemFontOfSize:12];
        _topLeftLabel.textColor = ETTextColor_Sixth;
        _topLeftLabel.textAlignment = NSTextAlignmentLeft;
        _topLeftLabel.hidden = YES;
    }
    return _topLeftLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ETTextColor_Second;
    }
    return _lineView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = ETTextColor_Sixth;
        _contentLabel.numberOfLines = 2;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _contentLabel;
}

- (UIPickerView *)contentPicker {
    if (!_contentPicker) {
        _contentPicker = [[UIPickerView alloc] init];
        _contentPicker.delegate = self;
        _contentPicker.dataSource = self;
        _contentPicker.transform = CGAffineTransformMakeRotation(M_PI * 3 / 2);
        _contentPicker.userInteractionEnabled = NO;
        _contentPicker.hidden = YES;
    }
    return _contentPicker;
}

- (UIButton *)leftCenterButton {
    if (!_leftCenterButton) {
        _leftCenterButton = [[UIButton alloc] init];
        [_leftCenterButton setImage:[UIImage imageNamed:pk_train_left_arrows_red] forState:UIControlStateNormal];
        _leftCenterButton.hidden = YES;
    }
    return _leftCenterButton;
}

- (UIButton *)rightCenterButton {
    if (!_rightCenterButton) {
        _rightCenterButton = [[UIButton alloc] init];
        [_rightCenterButton setImage:[UIImage imageNamed:pk_train_right_arrows_red] forState:UIControlStateNormal];
        _rightCenterButton.hidden = YES;
    }
    return _rightCenterButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.backgroundColor = ETTextColor_Second;
        _leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_leftButton setTitle:@"结束训练" forState:UIControlStateNormal];
        [_leftButton setTitleColor:ETTextColor_Fourth forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.backgroundColor = ETMarkYellowColor;
        _rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_rightButton setTitle:@"继续训练" forState:UIControlStateNormal];
        [_rightButton setTitleColor:ETTextColor_Sixth forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _rightButton;
}

#pragma mark -- UIPickerViewDelegate --

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%@", self.dataArray[row]);
    self.selectIndex = row;
    self.selectData = self.dataArray[self.selectIndex];
    [pickerView reloadComponent:component];
}

#pragma mark -- UIPickerViewDataSource --

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = [[UILabel alloc] init];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = row == self.selectIndex ? ETTextColor_Sixth : ETClearColor;
    pickerLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    pickerLabel.text = self.dataArray[row];
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
