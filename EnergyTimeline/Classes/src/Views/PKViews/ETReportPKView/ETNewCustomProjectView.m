//
//  ETNewCustomProjectView.m
//  能量圈
//
//  Created by 王斌 on 2018/2/1.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETNewCustomProjectView.h"

@interface ETNewCustomProjectView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *shadowButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIPickerView *unitPicker;

@property (nonatomic, strong) UILabel *sureLabel;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation ETNewCustomProjectView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.shadowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@35);
        make.right.equalTo(@-35);
//        make.top.equalTo(weakSelf.shadowButton).with.offset(ETScreenH * 0.4);
        make.centerY.equalTo(weakSelf.shadowButton).with.offset(-30);
        make.height.equalTo(@(250));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.top.equalTo(@8);
        make.width.height.equalTo(@40);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-15);
        make.centerY.equalTo(weakSelf.backButton);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(@60);
        make.height.equalTo(@1);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom).with.offset(40);
        make.centerX.equalTo(weakSelf.contentView);
        make.height.equalTo(@40);
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
    }];
    
    [self.unitPicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(weakSelf.contentView);
//        make.top.equalTo(weakSelf.lineView.mas_bottom);
//        make.bottom.equalTo(weakSelf.nextButton.mas_top);
        make.center.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.contentView.mas_width);
        make.width.equalTo(@130);
    }];
    
    [self.sureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.nextButton.mas_top);
    }];
    
    [@[self.cancelButton, self.sureButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[self.cancelButton, self.sureButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(@60);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.equalTo(@60);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)init {
    if (self = [super initWithFrame:ETScreenB]) {
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

//- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
//    self.viewModel = (ETNewCustomProjectViewModel *)viewModel;
//    return [super initWithViewModel:viewModel];
//}

- (void)et_setupViews {
    [self addSubview:self.shadowButton];
    [self.shadowButton addSubview:self.contentView];
    [self.contentView addSubview:self.backButton];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.unitPicker];
    [self.contentView addSubview:self.sureLabel];
    [self.contentView addSubview:self.nextButton];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.sureButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.setNameSubject subscribeNext:^(NSString *projectName) {
        @strongify(self)
        self.viewModel.projectName = projectName;
        self.textField.text = projectName;
        [self.textField becomeFirstResponder];
    }];
    
    [self.viewModel.stautsChangeSubject subscribeNext:^(id x) {
        @strongify(self)
        [UIView transitionWithView:self.contentView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            switch (self.viewModel.customStatus) {
                                case ETNewCustomProjectStatusName: {
                                    self.rightLabel.text = @"添加新习惯";
                                    self.cancelButton.hidden = YES;
                                    self.sureButton.hidden = YES;
                                    self.nextButton.hidden = NO;
                                    self.textField.hidden = NO;
                                    self.unitPicker.hidden = YES;
                                    self.sureLabel.hidden = YES;
                                }
                                    break;
                                case ETNewCustomProjectStatusUnit: {
                                    self.rightLabel.text = @"添加单位";
                                    self.cancelButton.hidden = YES;
                                    self.sureButton.hidden = YES;
                                    self.nextButton.hidden = NO;
                                    self.textField.hidden = YES;
                                    self.unitPicker.hidden = NO;
                                    self.sureLabel.hidden = YES;
                                }
                                    break;
                                case ETNewCustomProjectStatusFinish: {
                                    self.rightLabel.text = @"提示";
                                    self.cancelButton.hidden = NO;
                                    self.sureButton.hidden = NO;
                                    self.nextButton.hidden = YES;
                                    self.textField.hidden = YES;
                                    self.unitPicker.hidden = YES;
                                    self.sureLabel.hidden = NO;
                                    self.viewModel.projectName = self.textField.text;
                                    self.sureLabel.text = [NSString stringWithFormat:@"您即将创建\"%@\"卡\n单位为\"%@\"", self.viewModel.projectName, self.viewModel.unit];
                                }
                                    break;
                                default:
                                    break;
                            }
                        } completion:^(BOOL finished) {
                            NSLog(@"%ld", (long)self.viewModel.customStatus);
                        }];
    }];
    
    [self.viewModel.removeSubject subscribeNext:^(id x) {
        @strongify(self)
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             self.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }];
}

#pragma mark -- layzLoad --

- (UIButton *)shadowButton {
    if (!_shadowButton) {
        _shadowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shadowButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _shadowButton.adjustsImageWhenHighlighted = NO; // 取消高亮
        @weakify(self)
        [[_shadowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.removeSubject sendNext:nil];
        }];
    }
    return _shadowButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ETWhiteColor;
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:ETLeftArrow_Gray] forState:UIControlStateNormal];
        [_backButton.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightSemibold]];
        @weakify(self)
        [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            NSLog(@"后退");
            if (self.viewModel.customStatus == ETNewCustomProjectStatusName) {
                [self.viewModel.removeSubject sendNext:nil];
            } else {
                self.viewModel.customStatus -= 1;
                [self.viewModel.stautsChangeSubject sendNext:nil];
            }
        }];
    }
    return _backButton;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _rightLabel.textColor = ETTextColor_Sixth;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.text = @"添加新习惯";
    }
    return _rightLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ETTextColor_Second;
    }
    return _lineView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        _textField.textAlignment = NSTextAlignmentCenter;
        [_textField setTintColor:ETTextColor_Sixth];
        _textField.userInteractionEnabled = YES;
//        _textField.placeholder = @"请输入习惯名称";
    }
    return _textField;
}

- (UIPickerView *)unitPicker {
    if (!_unitPicker) {
        _unitPicker = [[UIPickerView alloc] init];
        _unitPicker.delegate = self;
        _unitPicker.dataSource = self;
        _unitPicker.transform = CGAffineTransformMakeRotation(M_PI * 3 / 2);
        _unitPicker.hidden = YES;
    }
    return _unitPicker;
}

- (UILabel *)sureLabel {
    if (!_sureLabel) {
        _sureLabel = [[UILabel alloc] init];
        _sureLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        _sureLabel.textAlignment = NSTextAlignmentCenter;
        _sureLabel.textColor = ETTextColor_Sixth;
        _sureLabel.numberOfLines = 2;
        _sureLabel.hidden = YES;
    }
    return _sureLabel;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        _nextButton.backgroundColor = ETMinorColor;
        _nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:ETTextColor_First forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
        @weakify(self)
        [[_nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            NSLog(@"下一步");
            if (![self.textField.text isEqualToString:@""]) {
                self.viewModel.customStatus += 1;
                [self.viewModel.stautsChangeSubject sendNext:nil];
            }
        }];
    }
    return _nextButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = ETTextColor_Second;
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:ETTextColor_Fourth forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelButton.hidden = YES;
        @weakify(self)
        [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            NSLog(@"取消");
            [self.viewModel.removeSubject sendNext:nil];
        }];
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        _sureButton.backgroundColor = ETMinorColor;
        _sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:ETTextColor_First forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureButton.hidden = YES;
        @weakify(self)
        [[_sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [MobClick event:@"ETNewCustomProject_SureCreateClick"];
            NSLog(@"确定");
            [self.viewModel.newProjectCommand execute:nil];
        }];
    }
    return _sureButton;
}

- (ETNewCustomProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETNewCustomProjectViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- UIPickerViewDelegate --

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%ld", (long)component);
    self.viewModel.unit = self.viewModel.unitArray[row];
}

#pragma mark -- UIPickerViewDataSource --

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.viewModel.unitArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = [[UILabel alloc] init];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = ETTextColor_Sixth;
    pickerLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    pickerLabel.text = self.viewModel.unitArray[row];
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
