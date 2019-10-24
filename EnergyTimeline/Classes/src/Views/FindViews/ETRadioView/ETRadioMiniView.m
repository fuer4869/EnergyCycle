//
//  ETRadioMiniView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/6.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRadioMiniView.h"
#import "ETRadioViewModel.h"
#import "ETRadioManager.h"

static NSString * const radio_mini_play = @"radio_mini_play";
static NSString * const radio_mini_pause = @"radio_mini_pause";
static NSString * const radio_mini_timePlay = @"radio_mini_timePlay";
static NSString * const radio_mini_timeStop = @"radio_mini_timeStop";
static NSString * const radio_mini_more = @"radio_mini_more";

@interface ETRadioMiniView ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UIButton *radioMini;

@property (nonatomic, strong) UILabel *radioName;

@property (nonatomic, strong) UIButton *timePlay;

@property (nonatomic, strong) UIButton *timeStop;

@property (nonatomic, strong) UIButton *more;

@property (nonatomic, strong) ETRadioViewModel *viewModel;

@end

@implementation ETRadioMiniView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETRadioViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf);
//        make.bottom.equalTo(weakSelf);
//        make.left.equalTo(weakSelf).with.offset(10);
//        make.right.equalTo(weakSelf).with.offset(-10);
        make.edges.equalTo(weakSelf);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView).with.offset(20);
        make.top.equalTo(weakSelf.containerView).with.offset(16);
        make.width.equalTo(@3);
        make.height.equalTo(@12);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tagView.mas_right).with.offset(5);
        make.centerY.equalTo(weakSelf.tagView);
    }];

    [self.radioMini mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.tagView.mas_right);
        make.top.equalTo(weakSelf.tagView.mas_bottom).with.offset(10);
        make.width.height.equalTo(@40);
    }];
    
    [self.radioName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.radioMini.mas_right).with.offset(10);
        make.right.equalTo(weakSelf.timePlay.mas_left);
        make.centerY.equalTo(weakSelf.radioMini);
    }];
    
    [self.timePlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.timeStop.mas_left).with.offset(-5);
        make.centerY.equalTo(weakSelf.radioMini);
    }];
    
    [self.timeStop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.more.mas_left).with.offset(-5);
        make.centerY.equalTo(weakSelf.radioMini);
    }];
    
    [self.more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.containerView).with.offset(-20);
        make.centerY.equalTo(weakSelf.radioMini);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.tagView];
    [self.containerView addSubview:self.tagLabel];
    [self.containerView addSubview:self.radioMini];
    [self.containerView addSubview:self.radioName];
    [self.containerView addSubview:self.timePlay];
    [self.containerView addSubview:self.timeStop];
    [self.containerView addSubview:self.more];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.radioDataCommand execute:nil];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.radioMini setImage:[UIImage imageNamed:[[ETRadioManager sharedInstance] playing] ? radio_mini_pause : radio_mini_play] forState:UIControlStateNormal];
        [self.radioMini sd_setBackgroundImageWithURL:[NSURL URLWithString:[self.viewModel.radioModel Radio_Icon]] forState:UIControlStateNormal];
        self.radioName.text = self.viewModel.radioModel.RadioName;
    }];
    
    [self.viewModel.replaceEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.radioMini setImage:[UIImage imageNamed:[[ETRadioManager sharedInstance] playing] ? radio_mini_pause : radio_mini_play] forState:UIControlStateNormal];
        [self.radioMini sd_setBackgroundImageWithURL:[NSURL URLWithString:[self.viewModel.radioModel Radio_Icon]] forState:UIControlStateNormal];
        self.radioName.text = self.viewModel.radioModel.RadioName;
    }];
}

#pragma mark -- lazyLoad --

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = ETMinorBgColor;
//        _containerView.layer.cornerRadius = 10;
//        _containerView.layer.shadowColor = [UIColor colorWithHexString:@"154b8a"].CGColor;
//        _containerView.layer.shadowOpacity = 0.1;
//        _containerView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _containerView;
}

- (UIView *)tagView {
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        _tagView.backgroundColor = [UIColor colorWithHexString:@"FFE10C"];
    }
    return _tagView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.text = @"英语电台";
        _tagLabel.textColor = ETTextColor_First;
        [_tagLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    return _tagLabel;
}

- (UIButton *)radioMini {
    if (!_radioMini) {
        _radioMini = [[UIButton alloc] init];
        _radioMini.layer.cornerRadius = 10;
        _radioMini.layer.masksToBounds = YES;
        @weakify(self)
        [[_radioMini rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (![[ETRadioManager sharedInstance] playing]) {
                [_radioMini setImage:[UIImage imageNamed:radio_mini_pause] forState:UIControlStateNormal];
                [[ETRadioManager sharedInstance] playUrlWithString:[self.viewModel.radioModel RadioUrl]];
            } else {
                [_radioMini setImage:[UIImage imageNamed:radio_mini_play] forState:UIControlStateNormal];
                [[ETRadioManager sharedInstance] pause];
            }
        }];
    }
    return _radioMini;
}


- (UILabel *)radioName {
    if (!_radioName) {
        _radioName = [[UILabel alloc] init];
        _radioName.textColor = ETTextColor_Second;
        [_radioName setFont:[UIFont boldSystemFontOfSize:14]];
    }
    return _radioName;
}

- (UIButton *)timePlay {
    if (!_timePlay) {
        _timePlay = [[UIButton alloc] init];
        [_timePlay.titleLabel setFont:[UIFont systemFontOfSize:8]];
        [_timePlay setTitle:@"定时播放" forState:UIControlStateNormal];
        [_timePlay setTitleColor:ETLightBlackColor forState:UIControlStateNormal];
        [_timePlay setImage:[UIImage imageNamed:radio_mini_timePlay] forState:UIControlStateNormal];
        @weakify(self)
        [[_timePlay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.radioPlayVCSubject sendNext:nil];
        }];
    }
    return _timePlay;
}

- (UIButton *)timeStop {
    if (!_timeStop) {
        _timeStop = [[UIButton alloc] init];
        [_timeStop.titleLabel setFont:[UIFont systemFontOfSize:8]];
        [_timeStop setTitle:@"定时停止" forState:UIControlStateNormal];
        [_timeStop setTitleColor:ETLightBlackColor forState:UIControlStateNormal];
        [_timeStop setImage:[UIImage imageNamed:radio_mini_timeStop] forState:UIControlStateNormal];
        @weakify(self)
        [[_timeStop rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.radioDurationTimeVCSubject sendNext:nil];
        }];
    }
    return _timeStop;
}

- (UIButton *)more {
    if (!_more) {
        _more = [[UIButton alloc] init];
        [_more.titleLabel setFont:[UIFont systemFontOfSize:8]];
        [_more setTitle:@"更多" forState:UIControlStateNormal];
        [_more setTitleColor:ETLightBlackColor forState:UIControlStateNormal];
        [_more setImage:[UIImage imageNamed:radio_mini_more] forState:UIControlStateNormal];
        @weakify(self)
        [[_more rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.radioVCSubject sendNext:nil];
        }];
    }
    return _more;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
