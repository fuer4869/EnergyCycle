//
//  ETTrainPauseView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/22.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainPauseView.h"

static NSString * const pk_train_over = @"pk_train_over";

static NSString * const pk_train_continue = @"pk_train_continue";

@interface ETTrainPauseView ()

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UIButton *overButton;

@property (nonatomic, strong) UILabel *overLabel;

@property (nonatomic, strong) UIButton *continueButton;

@property (nonatomic, strong) UILabel *continueLabel;



@end

@implementation ETTrainPauseView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.overButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf);
    }];
    
    [self.overLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.overButton);
        make.top.equalTo(weakSelf.overButton.mas_bottom).with.offset(12);
    }];
    
    [self.continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf);
    }];
    
    [self.continueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.continueButton);
        make.top.equalTo(weakSelf.continueButton.mas_bottom).with.offset(12);
    }];
    
    [super updateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.shadowView];
    [self addSubview:self.overButton];
    [self addSubview:self.overLabel];
    [self addSubview:self.continueButton];
    [self addSubview:self.continueLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
}

#pragma mark -- lazyLoad --

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _shadowView;
}

- (UIButton *)overButton {
    if (!_overButton) {
        _overButton = [[UIButton alloc] init];
        [_overButton setImage:[UIImage imageNamed:pk_train_over] forState:UIControlStateNormal];
        @weakify(self)
        [[_overButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(trainOver)]) {
                [self.delegate trainOver];
            }
            [self removeFromSuperview];
        }];
    }
    return _overButton;
}

- (UILabel *)overLabel {
    if (!_overLabel) {
        _overLabel = [[UILabel alloc] init];
        _overLabel.textColor = ETTextColor_Fifth;
        _overLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _overLabel.text = @"结束训练";
    }
    return _overLabel;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [[UIButton alloc] init];
        [_continueButton setImage:[UIImage imageNamed:pk_train_continue] forState:UIControlStateNormal];
        @weakify(self)
        [[_continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [MobClick event:@"ETTrainContinueClick"];
            if ([self.delegate respondsToSelector:@selector(trainContinue)]) {
                [self.delegate trainContinue];
            }
            [self removeFromSuperview];
        }];
    }
    return _continueButton;
}

- (UILabel *)continueLabel {
    if (!_continueLabel) {
        _continueLabel = [[UILabel alloc] init];
        _continueLabel.textColor = ETTextColor_Fifth;
        _continueLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _continueLabel.text = @"继续训练";
    }
    return _continueLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
