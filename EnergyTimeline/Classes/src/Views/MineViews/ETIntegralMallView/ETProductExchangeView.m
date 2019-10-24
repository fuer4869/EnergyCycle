//
//  ETProductExchangeView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProductExchangeView.h"
#import "ETProductExchangeViewModel.h"

@interface ETProductExchangeView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *receiverView;

@property (nonatomic, strong) UIView *receivePhoneView;

@property (nonatomic, strong) UIView *receiveAddressView;

@property (nonatomic, strong) UILabel *receiverLabel;

@property (nonatomic, strong) UILabel *receivePhoneLabel;

@property (nonatomic, strong) UILabel *receiveAddressLabel;

@property (nonatomic, strong) UITextField *receiverTextField;

@property (nonatomic, strong) UITextField *receivePhoneTextField;

@property (nonatomic, strong) UITextView *receiveAddressTextView;

@property (nonatomic, strong) UIButton *exchangeButton;

@property (nonatomic, strong) ETProductExchangeViewModel *viewModel;

@end

@implementation ETProductExchangeView

- (void)updateConstraints {
    WS(weakSelf)
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.height.equalTo(@200);
    }];
    
    [self.receiverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@60);
    }];
    
    [self.receivePhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.receiverView.mas_bottom);
        make.height.equalTo(@60);
    }];
    
    [self.receiveAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.receivePhoneView.mas_bottom);
    }];
    
    [self.receiverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.receiverView).with.offset(15);
        make.centerY.equalTo(weakSelf.receiverView);
        make.width.equalTo(@90);
    }];
    
    [self.receiverTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.receiverView);
        make.left.equalTo(weakSelf.receiverLabel.mas_right);
        make.right.equalTo(weakSelf.receiverView).with.offset(-15);
    }];
    
    [self.receivePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.receivePhoneView).with.offset(15);
        make.centerY.equalTo(weakSelf.receivePhoneView);
        make.width.equalTo(@90);
    }];
    
    [self.receivePhoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.receivePhoneView);
        make.left.equalTo(weakSelf.receivePhoneLabel.mas_right);
        make.right.equalTo(weakSelf.receivePhoneView).with.offset(-15);
    }];
    
    [self.receiveAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.receiveAddressView).with.offset(15);
        make.top.equalTo(weakSelf.receiveAddressView).with.offset(20);
        make.width.equalTo(@83);
    }];
    
    [self.receiveAddressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.receiveAddressView);
        make.left.equalTo(weakSelf.receiveAddressLabel.mas_right);
        make.right.equalTo(weakSelf.receiveAddressView).with.offset(-15);
    }];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(50);
        make.right.equalTo(weakSelf).with.offset(-50);
        make.top.equalTo(weakSelf.contentView.mas_bottom).with.offset(30);
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETProductExchangeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.receiverView];
    [self.contentView addSubview:self.receivePhoneView];
    [self.contentView addSubview:self.receiveAddressView];
    [self.receiverView addSubview:self.receiverLabel];
    [self.receiverView addSubview:self.receiverTextField];
    [self.receivePhoneView addSubview:self.receivePhoneLabel];
    [self.receivePhoneView addSubview:self.receivePhoneTextField];
    [self.receiveAddressView addSubview:self.receiveAddressLabel];
    [self.receiveAddressView addSubview:self.receiveAddressTextView];
    
    [self addSubview:self.exchangeButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
    RAC(self.viewModel, receiver) = self.receiverTextField.rac_textSignal;
    RAC(self.viewModel, receivePhone) = self.receivePhoneTextField.rac_textSignal;
    RAC(self.viewModel, receiveAddress) = self.receiveAddressTextView.rac_textSignal;
    RAC(self.exchangeButton, enabled) = self.viewModel.exchangeEnableSignal;
    
}

#pragma mark -- lazyLoad --

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ETMinorBgColor;
        _contentView.layer.cornerRadius = 10;
//        _contentView.layer.shadowColor = ETMinorColor.CGColor;
//        _contentView.layer.shadowOpacity = 0.1;
//        _contentView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _contentView;
}

- (UIView *)receiverView {
    if (!_receiverView) {
        _receiverView = [[UIView alloc] init];
    }
    return _receiverView;
}

- (UIView *)receivePhoneView {
    if (!_receivePhoneView) {
        _receivePhoneView = [[UIView alloc] init];
    }
    return _receivePhoneView;
}

- (UIView *)receiveAddressView {
    if (!_receiveAddressView) {
        _receiveAddressView = [[UIView alloc] init];
    }
    return _receiveAddressView;
}

- (UILabel *)receiverLabel {
    if (!_receiverLabel) {
        _receiverLabel = [[UILabel alloc] init];
        _receiverLabel.textColor = ETTextColor_Fourth;
        _receiverLabel.text = @"收货人";
        _receiverLabel.font = [UIFont systemFontOfSize:16];
    }
    return _receiverLabel;
}

- (UILabel *)receivePhoneLabel {
    if (!_receivePhoneLabel) {
        _receivePhoneLabel = [[UILabel alloc] init];
        _receivePhoneLabel.textColor = ETTextColor_Fourth;
        _receivePhoneLabel.text = @"联系电话";
        _receivePhoneLabel.font = [UIFont systemFontOfSize:16];
    }
    return _receivePhoneLabel;
}

- (UILabel *)receiveAddressLabel {
    if (!_receiveAddressLabel) {
        _receiveAddressLabel = [[UILabel alloc] init];
        _receiveAddressLabel.textColor = ETTextColor_Fourth;
        _receiveAddressLabel.text = @"收货地址";
        _receiveAddressLabel.font = [UIFont systemFontOfSize:16];
    }
    return _receiveAddressLabel;
}

- (UITextField *)receiverTextField {
    if (!_receiverTextField) {
        _receiverTextField = [[UITextField alloc] init];
        _receiverTextField.textColor = ETTextColor_First;
        _receiverTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _receiverTextField;
}

- (UITextField *)receivePhoneTextField {
    if (!_receivePhoneTextField) {
        _receivePhoneTextField = [[UITextField alloc] init];
        _receivePhoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _receivePhoneTextField.textColor = ETTextColor_First;
        _receivePhoneTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _receivePhoneTextField;
}

- (UITextView *)receiveAddressTextView {
    if (!_receiveAddressTextView) {
        _receiveAddressTextView = [[UITextView alloc] init];
        _receiveAddressTextView.backgroundColor = ETMinorBgColor;
        _receiveAddressTextView.textColor = ETTextColor_First;
        _receiveAddressTextView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _receiveAddressTextView;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [[UIButton alloc] init];
//        _exchangeButton.backgroundColor = [UIColor colorWithHexString:@"F24D4C"];
        _exchangeButton.backgroundColor = ETMinorColor;
        [_exchangeButton setTitle:@"确定" forState:UIControlStateNormal];
        [_exchangeButton setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        _exchangeButton.layer.cornerRadius = 25;
        @weakify(self)
        [[_exchangeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.exchangeCommand execute:nil];
//            [self.viewModel.exchangeEndSubject sendNext:nil];
//            NSLog(@"%d%@%@%@", self.viewModel.productID, self.viewModel.receiver, self.viewModel.receivePhone, self.viewModel.receiveAddress);
        }];
    }
    return _exchangeButton;
}

- (ETProductExchangeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProductExchangeViewModel alloc] init];
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
