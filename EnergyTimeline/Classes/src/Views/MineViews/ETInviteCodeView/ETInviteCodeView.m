//
//  ETInviteCodeView.m
//  能量圈
//
//  Created by 王斌 on 2018/2/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETInviteCodeView.h"
#import "ETInviteCodeViewModel.h"

@interface ETInviteCodeView ()

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) ETInviteCodeViewModel *viewModel;

@end

@implementation ETInviteCodeView

- (void)updateConstraints {
    WS(weakSelf)
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(@20);
        make.right.top.equalTo(weakSelf);
        make.height.equalTo(@50);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topLabel.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETInviteCodeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.topLabel];
    [self addSubview:self.textField];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.textField.rac_textSignal subscribeNext:^(NSString *string) {
        self.viewModel.inviteCode = string;
    }];
}

#pragma mark -- lazyLoad --

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.text = @"请输入推荐人能量源";
        _topLabel.textColor = ETTextColor_Second;
        _topLabel.font = [UIFont systemFontOfSize:15];
    }
    return _topLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.backgroundColor = ETMinorBgColor;
        _textField.textColor = ETTextColor_Second;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeNumberPad; // 设置数字键盘
        [_textField becomeFirstResponder];
    }
    return _textField;
}

- (ETInviteCodeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETInviteCodeViewModel alloc] init];
    }
    return _viewModel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
