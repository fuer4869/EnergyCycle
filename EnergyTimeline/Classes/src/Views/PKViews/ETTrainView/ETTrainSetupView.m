//
//  ETTrainSetupView.m
//  能量圈
//
//  Created by 王斌 on 2018/4/16.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainSetupView.h"
#import "ETTrainViewModel.h"
#import "ETSlider.h"
#import "ETTrainAudioManager.h"

static NSString * const close_white = @"close_white";
static NSString * const pk_projectRank_cancel_white = @"pk_projectRank_cancel_white";
static NSString * const pk_train_yellow_volume = @"pk_train_yellow_volume";
static NSString * const pk_train_previous_track = @"pk_train_previous_track";
static NSString * const pk_train_next_track = @"pk_train_next_track";

static NSString * const slider_thumb_yellow = @"slider_thumb_yellow";
static NSString * const slider_thumb_invisible = @"slider_thumb_invisible";
static NSString * const slider_yellow = @"slider_yellow";
static NSString * const slider_light_yellow = @"slider_light_yellow";

@interface ETTrainSetupView ()

@property (nonatomic, strong) UIButton *shadowView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UILabel *bgmLabel;

@property (nonatomic, strong) UISwitch *bgmSwitch;

@property (nonatomic, strong) UIButton *previousTrackButton;

@property (nonatomic, strong) UILabel *currentBgmLabel;

@property (nonatomic, strong) UIButton *nextTrackButton;

@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UIImageView *bgmVolumeIcon;

@property (nonatomic, strong) ETSlider *bgmVolumeSlider;

@property (nonatomic, strong) ETTrainViewModel *viewModel;

@end

@implementation ETTrainSetupView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.shadowView);
        make.height.equalTo(@300);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@23);
        make.right.equalTo(@-30);
        make.width.height.equalTo(@50);
    }];
    
    [self.bgmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@45);
        make.centerY.equalTo(weakSelf.bgmSwitch);
    }];
    
    [self.bgmSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).with.offset(107);
        make.right.equalTo(@-45);
    }];
    
    [self.previousTrackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@45);
        make.top.equalTo(weakSelf.bgmSwitch.mas_bottom).with.offset(30);
    }];
    
    [self.currentBgmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.previousTrackButton);
    }];
    
    [self.nextTrackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-45);
        make.centerY.equalTo(weakSelf.previousTrackButton);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.currentBgmLabel);
    }];
    
    [self.bgmVolumeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@45);
        make.centerY.equalTo(weakSelf.bgmVolumeSlider);
    }];
    
    [self.bgmVolumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-45);
        make.left.equalTo(weakSelf.bgmVolumeIcon.mas_right).with.offset(5);
        make.top.equalTo(weakSelf.nextTrackButton.mas_bottom).with.offset(30);
    }];
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETTrainViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.shadowView];
    [self.shadowView addSubview:self.contentView];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.bgmLabel];
    [self.contentView addSubview:self.bgmSwitch];
    [self.contentView addSubview:self.previousTrackButton];
    [self.contentView addSubview:self.currentBgmLabel];
    [self.contentView addSubview:self.nextTrackButton];
    [self.contentView addSubview:self.remindLabel];
    [self.contentView addSubview:self.bgmVolumeIcon];
    [self.contentView addSubview:self.bgmVolumeSlider];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.trainFinishSubject subscribeNext:^(id x) {
        @strongify(self)
        [self removeFromSuperview];
    }];
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self removeFromSuperview];
    }];
    
    [[self.bgmSwitch rac_newOnChannel] subscribeNext:^(id value) {
        [[ETTrainAudioManager sharedInstance] bgmOpenChange];
        self.previousTrackButton.hidden = ![[ETTrainAudioManager sharedInstance] bgmOpen];
        self.currentBgmLabel.hidden = ![[ETTrainAudioManager sharedInstance] bgmOpen];
        self.nextTrackButton.hidden = ![[ETTrainAudioManager sharedInstance] bgmOpen];
        self.remindLabel.hidden = [[ETTrainAudioManager sharedInstance] bgmOpen];
        self.bgmVolumeIcon.alpha = [[ETTrainAudioManager sharedInstance] bgmOpen] ? 1.0 : 0.2;
//        self.bgmVolumeSlider.enabled = [[ETTrainAudioManager sharedInstance] bgmOpen];
        
        self.bgmVolumeSlider.userInteractionEnabled = [[ETTrainAudioManager sharedInstance] bgmOpen];
        [self.bgmVolumeSlider setThumbImage:[UIImage imageNamed:[[ETTrainAudioManager sharedInstance] bgmOpen] ? slider_thumb_yellow : slider_thumb_invisible] forState:UIControlStateNormal];
        [self.bgmVolumeSlider setMinimumTrackTintColor:[[UIColor jk_colorWithHexString:@"FFD91E"] colorWithAlphaComponent:[[ETTrainAudioManager sharedInstance] bgmOpen] ? 1.0 : 0.2]];
    }];
    
    RACSignal *signal = [[self.bgmVolumeSlider rac_newValueChannelWithNilValue:@0] startWith:[NSNumber numberWithFloat:[[ETTrainAudioManager sharedInstance] bgmVolume]]];
    
    [[RACSignal combineLatest:@[signal] reduce:^id(NSNumber *value){
        NSLog(@"值为......%@", value);
        return value;
    }] subscribeNext:^(NSNumber *value) {
        [[ETTrainAudioManager sharedInstance] bgmVolumeChange:[value floatValue]];
    }];
    
    [[self.previousTrackButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
        [[ETTrainAudioManager sharedInstance] bgmPreviousTrack];
        self.currentBgmLabel.text = [[ETTrainAudioManager sharedInstance] bgmInfo];
    }];
    
    [[self.nextTrackButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
        [[ETTrainAudioManager sharedInstance] bgmNextTrack];
        self.currentBgmLabel.text = [[ETTrainAudioManager sharedInstance] bgmInfo];
    }];
    
}

#pragma mark -- lazyLoad --

- (UIButton *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIButton alloc] init];
        _shadowView.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.1];
    }
    return _shadowView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [ETMinorBgColor colorWithAlphaComponent:0.9];
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:close_white] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UILabel *)bgmLabel {
    if (!_bgmLabel) {
        _bgmLabel = [[UILabel alloc] init];
        _bgmLabel.text = @"背景音乐";
        _bgmLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _bgmLabel.textColor = ETTextColor_Fourth;
    }
    return _bgmLabel;
}

- (UISwitch *)bgmSwitch {
    if (!_bgmSwitch) {
        _bgmSwitch = [[UISwitch alloc] init];
        _bgmSwitch.onTintColor = ETMarkYellowColor;
        _bgmSwitch.on = [[ETTrainAudioManager sharedInstance] bgmOpen];
        _bgmSwitch.tintColor = ETGrayColor;
        _bgmSwitch.backgroundColor = ETGrayColor;
        _bgmSwitch.layer.cornerRadius = 16.0;
    }
    return _bgmSwitch;
}

- (UIButton *)previousTrackButton {
    if (!_previousTrackButton) {
        _previousTrackButton = [[UIButton alloc] init];
        [_previousTrackButton setImage:[UIImage imageNamed:pk_train_previous_track] forState:UIControlStateNormal];
        _previousTrackButton.hidden = ![[ETTrainAudioManager sharedInstance] bgmOpen];
    }
    return _previousTrackButton;
}

- (UILabel *)currentBgmLabel {
    if (!_currentBgmLabel) {
        _currentBgmLabel = [[UILabel alloc] init];
        _currentBgmLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _currentBgmLabel.textColor = ETTextColor_Fourth;
        _currentBgmLabel.hidden = ![[ETTrainAudioManager sharedInstance] bgmOpen];
        _currentBgmLabel.text = [[ETTrainAudioManager sharedInstance] bgmInfo];
    }
    return _currentBgmLabel;
}

- (UIButton *)nextTrackButton {
    if (!_nextTrackButton) {
        _nextTrackButton = [[UIButton alloc] init];
        [_nextTrackButton setImage:[UIImage imageNamed:pk_train_next_track] forState:UIControlStateNormal];
        _nextTrackButton.hidden = ![[ETTrainAudioManager sharedInstance] bgmOpen];
    }
    return _nextTrackButton;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _remindLabel.textColor = ETTextColor_Fourth;
        _remindLabel.text = @"你可以用喜欢的音乐播放器听音乐";
        _remindLabel.hidden = [[ETTrainAudioManager sharedInstance] bgmOpen];
    }
    return _remindLabel;
}

- (UIImageView *)bgmVolumeIcon {
    if (!_bgmVolumeIcon) {
        _bgmVolumeIcon = [[UIImageView alloc] init];
        [_bgmVolumeIcon setImage:[UIImage imageNamed:pk_train_yellow_volume]];
        _bgmVolumeIcon.alpha = [[ETTrainAudioManager sharedInstance] bgmOpen] ? 1.0 : 0.2;
    }
    return _bgmVolumeIcon;
}

- (ETSlider *)bgmVolumeSlider {
    if (!_bgmVolumeSlider) {
        _bgmVolumeSlider = [[ETSlider alloc] init];
        _bgmVolumeSlider.minimumValue = 0.0;
        _bgmVolumeSlider.maximumValue = 1.0;
        _bgmVolumeSlider.continuous = YES;
        _bgmVolumeSlider.value = [[ETTrainAudioManager sharedInstance] bgmVolume];
        [_bgmVolumeSlider setThumbImage:[UIImage imageNamed:[[ETTrainAudioManager sharedInstance] bgmOpen] ? slider_thumb_yellow : slider_thumb_invisible] forState:UIControlStateNormal];
        _bgmVolumeSlider.minimumTrackTintColor = [[UIColor jk_colorWithHexString:@"FFD91E"] colorWithAlphaComponent:[[ETTrainAudioManager sharedInstance] bgmOpen] ? 1.0 : 0.2];
        _bgmVolumeSlider.maximumTrackTintColor = [[UIColor jk_colorWithHexString:@"FFD91E"] colorWithAlphaComponent:0.2];
        _bgmVolumeSlider.userInteractionEnabled = [[ETTrainAudioManager sharedInstance] bgmOpen];
    }
    return _bgmVolumeSlider;
}

- (ETTrainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainViewModel alloc] init];
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
