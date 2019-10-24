//
//  ETBadgeView.m
//  能量圈
//
//  Created by 王斌 on 2017/11/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETBadgeView.h"
#import "ETRadioManager.h"

#import "ETShareView.h"
#import "ShareSDKManager.h"

/** 弹出视图动画时间 */
static CGFloat const kETPopAnimationDuration = 0.5;
/** 撤销视图动画时间 */
static CGFloat const kETDismissAnimationDuration = 0.5;

static NSString * const cancel = @"cancel_gray";

@interface ETBadgeView () <ETShareViewDelegate>

/** 弹框内容视图 */
@property (nonatomic, strong) UIView *contentView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 副标题 */
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) RACSubject *closeSubject;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation ETBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self bindEvent];
        
    }
    return self;
}

- (void)setup {
    [self addSubview:self.shadowView];
}

- (void)bindEvent {
    @weakify(self)
    
    [[self.closeSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (self.modelArray.count > 1) {
            [self.modelArray removeObjectAtIndex:0];
            [self next];
        } else {
            [self close];
        }
    }];
    
    [[self.shadowView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.closeSubject sendNext:nil];
    }];
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.closeSubject sendNext:nil];
    }];
    
    [[self.shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [ETShareView shareViewWithBottomWithDelegate:self];
    }];
    
}

/** 弹出动画 */
- (void)show {
//    [[ETRadioManager sharedInstance] playAudioType:ETAudioTypeGetBadge];
    self.shadowView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:kETPopAnimationDuration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.shadowView.alpha = 1.0f;
        self.contentView.transform = CGAffineTransformIdentity;
//        WS(weakSelf)
//        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(weakSelf.shadowView);
//        }];
//        [self layoutIfNeeded];
    } completion:nil];
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

- (void)next {
    [UIView animateWithDuration:kETDismissAnimationDuration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
//                         self.contentView.alpha = 0;
//                         self.alpha = 0;
//                         self.shadowView.alpha = 0;
                         self.contentView.transform = CGAffineTransformMakeScale(0, 0);
                     } completion:^(BOOL finished) {
                         [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         if (self.isPraise) {
//                             [self setupGetBadgeSubviewsWithModel:self.modelArray.firstObject];
                             [self setupGetPraiseSubviewsWithModel:self.modelArray.firstObject];
                         } else {
//                             [self setupSubviewsWithModel:self.modelArray.firstObject];
                             [self setupGetBadgeSubviewsWithModel:self.modelArray.firstObject];
                         }
                         [self show];
                     }];
}

#pragma mark -- 展示徽章 --

+ (ETBadgeView *)badgeViewWithModel:(ETBadgeModel *)model {
    
    ETBadgeView *badgeView = [[ETBadgeView alloc] initWithFrame:ETWindow.bounds];
    [badgeView setupSubviewsWithModel:model];
    [ETWindow addSubview:badgeView];
    [badgeView show];
    return badgeView;
}

+ (ETBadgeView *)badgeViewWithModels:(NSArray *)models {
    ETBadgeView *badgeView = [[ETBadgeView alloc] initWithFrame:ETWindow.bounds];
    [badgeView.modelArray setArray:models];
    [badgeView setupSubviewsWithModel:badgeView.modelArray.firstObject];
    [ETWindow addSubview:badgeView];
    [badgeView show];
    return badgeView;
}

- (void)setupSubviewsWithModel:(ETBadgeModel *)model {
    
    WS(weakSelf)
    
//    [_shadowView addSubview:self.contentView];
////    WS(weakSelf)
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.shadowView).with.offset(60);
//        make.right.equalTo(weakSelf.shadowView).with.offset(-60);
//        make.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(1.4);
//        make.centerY.equalTo(weakSelf.shadowView).with.offset(-ETScreenH);
//    }];
    
    [self.contentView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-6);
        make.top.equalTo(weakSelf.contentView).with.offset(6);
    }];
    
    UILabel *badgeHaveNum = [[UILabel alloc] init];
    badgeHaveNum.textAlignment = NSTextAlignmentCenter;
    badgeHaveNum.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
    badgeHaveNum.textColor = [UIColor jk_colorWithHexString:@"F6A623"];
    badgeHaveNum.text = [NSString stringWithFormat:@"-已有%@人获得-", model.HaveNum];
    [self.contentView addSubview:badgeHaveNum];
    [badgeHaveNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).with.offset(-35);
        make.height.equalTo(@15);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    UILabel *badgeName = [[UILabel alloc] init];
    badgeName.textAlignment = NSTextAlignmentCenter;
    badgeName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    badgeName.textColor = [UIColor jk_colorWithHexString:@"374C7E"];
    badgeName.text = model.BadgeName;
    [self.contentView addSubview:badgeName];
    [badgeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(badgeHaveNum.mas_top).with.offset(-24);
        make.height.equalTo(@25);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[model.Is_Have isEqualToString:@"1"] ? model.FilePath : model.FilePath_Gray]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).with.offset(20);
        make.left.equalTo(weakSelf.contentView).with.offset(38);
        make.bottom.equalTo(badgeName.mas_top).with.offset(-6);
    }];
    
}

#pragma mark -- 获得徽章 --

+ (ETBadgeView *)getBadgeViewWithModel:(ETBadgeModel *)model {
    ETBadgeView *badgeView = [[ETBadgeView alloc] initWithFrame:ETWindow.bounds];
    [badgeView setupGetBadgeSubviewsWithModel:model];
    [ETWindow addSubview:badgeView];
    [badgeView show];
    return badgeView;
}

+ (ETBadgeView *)getBadgeViewWithModels:(NSArray *)models {
    ETBadgeView *badgeView = [[ETBadgeView alloc] initWithFrame:ETWindow.bounds];
    [badgeView.modelArray setArray:models];
    [badgeView setupGetBadgeSubviewsWithModel:badgeView.modelArray.firstObject];
    [ETWindow addSubview:badgeView];
    [badgeView show];
    return badgeView;
}

- (void)setupGetBadgeSubviewsWithModel:(ETBadgeModel *)model {
    WS(weakSelf)
    
//    [_shadowView addSubview:self.contentView];
////    WS(weakSelf)
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.shadowView).with.offset(60);
//        make.right.equalTo(weakSelf.shadowView).with.offset(-60);
//        make.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(1.4);
//        make.centerY.equalTo(weakSelf.shadowView).with.offset(-ETScreenH);
//    }];
    
    [self.contentView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-6);
        make.top.equalTo(weakSelf.contentView).with.offset(6);
    }];
    
    [self.contentView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(25);
        make.right.equalTo(weakSelf.contentView).with.offset(-25);
        make.bottom.equalTo(weakSelf.contentView).with.offset(-20);
        make.height.equalTo(@46);
    }];

    
    UILabel *badgeHaveNum = [[UILabel alloc] init];
    badgeHaveNum.textAlignment = NSTextAlignmentCenter;
    badgeHaveNum.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
    badgeHaveNum.textColor = [UIColor jk_colorWithHexString:@"F6A623"];
    badgeHaveNum.text = [NSString stringWithFormat:@"-已有%@人获得-", model.HaveNum];
    [self.contentView addSubview:badgeHaveNum];
    [badgeHaveNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(badgeName.mas_top).with.offset(-24);
//        make.height.equalTo(@25);
//        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.shareButton.mas_top).with.offset(-35);
        make.height.equalTo(@15);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    
    UILabel *badgeName = [[UILabel alloc] init];
    badgeName.textAlignment = NSTextAlignmentCenter;
    badgeName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    badgeName.textColor = [UIColor jk_colorWithHexString:@"374C7E"];
    badgeName.numberOfLines = 2;
    badgeName.text = [NSString stringWithFormat:@"恭喜您!\n获得%@!", model.BadgeName];
    [self.contentView addSubview:badgeName];
    [badgeName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.contentView).with.offset(-35);
////        make.height.equalTo(@15);
//        make.centerX.equalTo(weakSelf.contentView);
        make.bottom.equalTo(badgeHaveNum.mas_top).with.offset(-10);
        make.height.equalTo(@45);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.contentView);
//        make.top.equalTo(weakSelf.contentView).with.offset(20);
//        make.left.equalTo(weakSelf.contentView).with.offset(38);
//        make.bottom.equalTo(badgeHaveNum.mas_top).with.offset(-6);
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).with.offset(20);
        make.bottom.equalTo(badgeName.mas_top).with.offset(-36);
    }];
    
}

/** 获得表彰 */

+ (ETBadgeView *)getPraiseViewWithModel:(ETPraiseModel *)model {
    ETBadgeView *badgeView = [[ETBadgeView alloc] initWithFrame:ETWindow.bounds];
    badgeView.isPraise = YES;
    [badgeView setupGetPraiseSubviewsWithModel:model];
    [ETWindow addSubview:badgeView];
    [badgeView show];
    return badgeView;
}

+ (ETBadgeView *)getPraiseViewWithModels:(NSArray *)models {
    ETBadgeView *badgeView = [[ETBadgeView alloc] initWithFrame:ETWindow.bounds];
    badgeView.isPraise = YES;
    [badgeView.modelArray setArray:models];
    [badgeView setupGetPraiseSubviewsWithModel:badgeView.modelArray.firstObject];
    [ETWindow addSubview:badgeView];
    [badgeView show];
    return badgeView;
}

- (void)setupGetPraiseSubviewsWithModel:(ETPraiseModel *)model {
    
    WS(weakSelf)
    
    [self.contentView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-6);
        make.top.equalTo(weakSelf.contentView).with.offset(6);
    }];
    
    [self.contentView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(25);
        make.right.equalTo(weakSelf.contentView).with.offset(-25);
        make.bottom.equalTo(weakSelf.contentView).with.offset(-20);
        make.height.equalTo(@46);
    }];
    
    UILabel *praiseHaveNum = [[UILabel alloc] init];
    praiseHaveNum.textAlignment = NSTextAlignmentCenter;
    praiseHaveNum.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
    praiseHaveNum.textColor = [UIColor jk_colorWithHexString:@"F6A623"];
    praiseHaveNum.text = [NSString stringWithFormat:@"-已有%@人获得-", model.HaveNum];
    [self.contentView addSubview:praiseHaveNum];
    [praiseHaveNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.shareButton.mas_top).with.offset(-35);
        make.height.equalTo(@15);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    UILabel *praiseName = [[UILabel alloc] init];
    praiseName.textAlignment = NSTextAlignmentCenter;
    praiseName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    praiseName.textColor = [UIColor jk_colorWithHexString:@"374C7E"];
    praiseName.numberOfLines = 2;
    praiseName.text = [NSString stringWithFormat:@"恭喜您!\n已累计完成%@%@%@!", model.PraiseNum, model.ProjectUnit, model.ProjectName];
    [self.contentView addSubview:praiseName];
    [praiseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(praiseHaveNum.mas_top).with.offset(-10);
        make.height.equalTo(@45);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView).with.offset(20);
        make.bottom.equalTo(praiseName.mas_top).with.offset(-36);
    }];
    
}

- (UIButton *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIButton buttonWithType:UIButtonTypeCustom];
        _shadowView.frame = ETWindow.bounds;
        _shadowView.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.7];
        _shadowView.alpha = 0;
        [_shadowView addSubview:self.contentView];
        WS(weakSelf)
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.shadowView).with.offset(60);
            make.right.equalTo(weakSelf.shadowView).with.offset(-60);
            make.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(1.4);
            make.centerY.equalTo(weakSelf.shadowView);
        }];
    }
    return _shadowView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:cancel] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.backgroundColor = ETMarkYellowColor;
        _shareButton.titleLabel.textColor = ETTextColor_First;
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _shareButton.layer.cornerRadius = 8;
        [_shareButton setTitle:@"点击分享" forState:UIControlStateNormal];
    }
    return _shareButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ETWhiteColor;
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (RACSubject *)closeSubject {
    if (!_closeSubject) {
        _closeSubject = [RACSubject subject];
    }
    return _closeSubject;
}

#pragma mark -- shareView --

- (ETShareModel *)shareModelNeedImage:(BOOL)need reversalTitle:(BOOL)reversal {
    ETShareModel *shareModel = [[ETShareModel alloc] init];
    if (self.isPraise) {
//        ETPraiseModel *model = self.modelArray.firstObject;
        shareModel.title = reversal ? @"更多表彰等你发现~" : [NSString stringWithFormat:@"%@的能量圈表彰墙", User_NickName];
        shareModel.content = reversal ? [NSString stringWithFormat:@"%@的能量圈表彰墙", User_NickName] : @"更多表彰等你发现~";
        shareModel.imageArray = need ? @[[UIImage imageNamed:@"mine_coverImg_default"]] : nil;
        shareModel.shareUrl = [NSString stringWithFormat:@"%@%@?UserID=%@", INTERFACE_URL, HTML_PKProjectPraise, User_ID];
    } else {
        shareModel.title = reversal ? @"更多徽章等你发现~" : [NSString stringWithFormat:@"%@的能量圈徽章墙", User_NickName];
        shareModel.content = reversal ? [NSString stringWithFormat:@"%@的能量圈徽章墙", User_NickName] : @"更多徽章等你发现~";
        shareModel.imageArray = need ? @[[UIImage imageNamed:@"mine_coverImg_default"]] : nil;
        shareModel.shareUrl = [NSString stringWithFormat:@"%@%@?UserID=%@", INTERFACE_URL, HTML_PKProjectBadge, User_ID];
    }
    return shareModel;
}

/** QQ空间分享 */
- (void)shareViewClickQzoneBtn {
    NSLog(@"qzone");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeQZone shareModel:[self shareModelNeedImage:NO reversalTitle:NO] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 微信分享 */
- (void)shareViewClickWechatSessionBtn {
    NSLog(@"wechat");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatSession shareModel:[self shareModelNeedImage:YES reversalTitle:NO] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 微博分享 */
- (void)shareViewClickSinaWeiboBtn {
    NSLog(@"sina");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformTypeSinaWeibo shareModel:[self shareModelNeedImage:NO reversalTitle:YES] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 朋友圈分享 */
- (void)shareViewClickWechatTimelineBtn {
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatTimeline shareModel:[self shareModelNeedImage:NO reversalTitle:NO] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
