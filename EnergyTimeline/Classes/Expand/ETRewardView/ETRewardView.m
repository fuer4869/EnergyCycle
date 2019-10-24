//
//  ETRewardView.m
//  能量圈
//
//  Created by 王斌 on 2017/7/14.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRewardView.h"

#import "UIImage+GIF.h"

/** 背景光 */
static NSString * const reward_light = @"reward_light";
/** 没有额外积分 */
static NSString * const reward_integral = @"reward_integral";
/** 有额外积分 */
static NSString * const reward_integral_extra = @"reward_integral_extra";
/** 阴影层不透明度 */
static CGFloat const kETShadowAlpha = 0.3;
/** 弹出视图动画时间 */
static CGFloat const kETRewardAnimationDuration = 0.3;
/** 关闭视图动画时间 */
static CGFloat const kETDismissAnimationDuration = 0.3;

@interface ETRewardView ()

/** 阴影层 */
@property (nonatomic, strong) UIButton *shadowView;

/** 内容视图 */
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *coreImageView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *extraLabel;

@end

@implementation ETRewardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.shadowView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shadowView.frame = ETWindow.bounds;
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kETShadowAlpha];
    [self.shadowView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.shadowView.adjustsImageWhenDisabled = NO; // 取消高亮
    [self addSubview:self.shadowView];
}

/** 弹出视图 */
- (void)show {
    self.shadowView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:kETRewardAnimationDuration
                          delay:0 usingSpringWithDamping:1.0
          initialSpringVelocity:1
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.shadowView.alpha = 1.0f;
        self.contentView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         self.duration ? [self addDuration] : nil;
                     }];
}

/** 视图持续时间 */
- (void)addDuration {
    [NSTimer jk_scheduledTimerWithTimeInterval:self.duration block:^{
        [self close];
    } repeats:NO];
}

/** 关闭视图 */
- (void)close {
    [UIView animateWithDuration:kETDismissAnimationDuration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
        self.contentView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -- 默认文本 --

+ (ETRewardView *)rewardViewWithContent:(NSString *)content {
    ETRewardView *rewardView = [[ETRewardView alloc] initWithFrame:ETWindow.bounds];
    [rewardView setupSubviewsWithContent:content];
    [ETWindow addSubview:rewardView];
    [rewardView show];
    return rewardView;
}

+ (ETRewardView *)rewardViewWithContent:(NSString *)content duration:(CGFloat)duration {
    ETRewardView *rewardView = [[ETRewardView alloc] initWithFrame:ETWindow.bounds];
    [rewardView setupSubviewsWithContent:content];
    rewardView.duration = duration;
    [ETWindow addSubview:rewardView];
    [rewardView show];
    return rewardView;
}

+ (ETRewardView *)rewardViewWithContent:(NSString *)content duration:(CGFloat)duration audioType:(ETAudioType)audioType {
    [[ETRadioManager sharedInstance] playAudioType:audioType];
    return [ETRewardView rewardViewWithContent:content duration:duration];
}

- (void)setupSubviewsWithContent:(NSString *)content {
    [self.shadowView addSubview:self.contentView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.coreImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.extraLabel];
    
    self.contentLabel.text = content;
    [self.coreImageView setImage:[UIImage imageNamed:reward_integral]];
    
    WS(weakSelf)
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.shadowView);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
    }];
    
    [self.coreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView).with.offset(30);
        make.left.equalTo(weakSelf.coreImageView.mas_left).with.offset(145);
    }];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        self.bgImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:nil];
    
    self.contentLabel.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.05 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentLabel.transform = CGAffineTransformMakeScale(3.0, 3.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentLabel.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ETIntegralReward"]];
//    [self.contentView addSubview:bgImageView];
//    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.contentView);
//    }];
//
//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.text = content;
//    contentLabel.textColor = [UIColor whiteColor];
//    contentLabel.font = [UIFont systemFontOfSize:16];
//    [self.contentView addSubview:contentLabel];
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.center.equalTo(self.contentView);
//        make.centerX.equalTo(self.contentView);
//        make.centerY.equalTo(self.contentView).with.offset(10);
//    }];
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Integral_reward"]];
//    [self.contentView addSubview:bgImageView];
//    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.contentView);
//    }];
//
////    UIWebView *fireworks = [[UIWebView alloc] init];
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Integral_fireworks" ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage sd_animatedGIFWithData:data];
//    UIImageView *gif = [[UIImageView alloc] initWithImage:image];
//    gif.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:gif];
//
//    [gif mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.shadowView);
//        make.center.equalTo(self.contentView).with.offset(-30);
//    }];
//
//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.text = content;
////    contentLabel.textColor = [UIColor whiteColor];
//    contentLabel.textColor = [UIColor jk_colorWithHexString:@"FF2727"];
//    contentLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightSemibold];
//    [self.contentView addSubview:contentLabel];
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.equalTo(self.contentView);
////        make.centerY.equalTo(self.contentView).with.offset(10);
//        make.centerY.equalTo(self.contentView);
//        make.right.equalTo(bgImageView).with.offset(-40);
//    }];
}

#pragma mark -- 默认文本 + 额外文本 --

+ (ETRewardView *)rewardViewWithContent:(NSString *)content extra:(NSString *)extra {
    ETRewardView *rewardView = [[ETRewardView alloc] initWithFrame:ETWindow.bounds];
    [rewardView setupSubviewsWithContent:content extra:extra];
    [ETWindow addSubview:rewardView];
    [rewardView show];
    return rewardView;
}

+ (ETRewardView *)rewardViewWithContent:(NSString *)content extra:(NSString *)extra duration:(CGFloat)duration {
    ETRewardView *rewardView = [[ETRewardView alloc] initWithFrame:ETWindow.bounds];
    [rewardView setupSubviewsWithContent:content extra:extra];
    rewardView.duration = duration;
    [ETWindow addSubview:rewardView];
    [rewardView show];
    return rewardView;
}

+ (ETRewardView *)rewardViewWithContent:(NSString *)content extra:(NSString *)extra duration:(CGFloat)duration audioType:(ETAudioType)audioType {
    [[ETRadioManager sharedInstance] playAudioType:audioType];
    return [ETRewardView rewardViewWithContent:content extra:extra duration:duration];
}

- (void)setupSubviewsWithContent:(NSString *)content extra:(NSString *)extra {
    [self.shadowView addSubview:self.contentView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.coreImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.extraLabel];
    
    self.contentLabel.text = content;
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:extra];
    [attributed addAttribute:NSForegroundColorAttributeName value:ETMinorColor range:NSMakeRange(9, attributed.length - 9)];
//    self.extraLabel.text = extra;
    self.extraLabel.attributedText = attributed;
    self.extraLabel.alpha = 0;
    [self.coreImageView setImage:[UIImage imageNamed:reward_integral_extra]];
    

    WS(weakSelf)
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.shadowView);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
    }];
    
    [self.coreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView).with.offset(30);
        make.left.equalTo(weakSelf.coreImageView.mas_left).with.offset(145);
    }];
    
    [self.extraLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.coreImageView);
        make.bottom.equalTo(weakSelf.coreImageView).with.offset(-45);
    }];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        self.bgImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:nil];
    
    self.contentLabel.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.05 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentLabel.transform = CGAffineTransformMakeScale(3.0, 3.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentLabel.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
    [UIView animateWithDuration:0 animations:^{
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:1.5 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.extraLabel.alpha = 1;
            [self.extraLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.coreImageView).with.offset(-80);
            }];
            [self layoutIfNeeded];
        } completion:nil];
    }];
    
}

#pragma mark -- lazyLoad --

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:reward_light]];
    }
    return _bgImageView;
}

- (UIImageView *)coreImageView {
    if (!_coreImageView) {
        _coreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:reward_integral_extra]];
    }
    return _coreImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor jk_colorWithHexString:@"8d6309"];
        _contentLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBold];
        _contentLabel.layer.shadowColor = [UIColor jk_colorWithHexString:@"8d6309"].CGColor;
        _contentLabel.layer.shadowOpacity = 0.1;
        _contentLabel.layer.shadowOffset = CGSizeMake(2, 2);
    }
    return _contentLabel;
}

- (UILabel *)extraLabel {
    if (!_extraLabel) {
        _extraLabel = [[UILabel alloc] init];
        _extraLabel.textColor = ETBlackColor;
        _extraLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    }
    return _extraLabel;
}

@end
