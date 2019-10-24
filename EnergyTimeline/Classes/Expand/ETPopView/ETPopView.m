//
//  ETPopView.m
//  能量圈
//
//  Created by 王斌 on 2017/4/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPopView.h"
#import "Masonry.h"
#import "UILabel+SizeToFit.h"

/** 阴影层不透明度 */
static CGFloat const kETShadowAlpha = 0.3;
/** 弹出视图动画时间 */
static CGFloat const kETPopAnimationDuration = 0.5;
/** 撤销视图动画时间 */
static CGFloat const kETDismissAnimationDuration = 0.5;
/** 文本字体大小 */
static CGFloat const kETTipFontOfSize = 14;
/** 标题字体大小 */
static CGFloat const kETTitleFontOfSize = 18;
/** 提示框与窗口的宽度比 */
static CGFloat const kETWindowWidthScale = 0.6;
/** 内容视图与文本视图的左右边距 */
static CGFloat const kETTipViewWithLeftAndRight = 35;
/** 内容视图与文本视图的上下边距 */
static CGFloat const kETTipViewWithTopAndBottom = 50;
/** 文本行间距 */
static CGFloat const kETTipLineSpacing = 5.0f;
/** 文本字间距 */
static CGFloat const kETTipWordSpacing = 0.5f;

@interface ETPopView ()

/** 弹框内容视图 */
@property (nonatomic, strong) UIView *contentView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容 */
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation ETPopView

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
    self.shadowClose = YES;
    [self.shadowView addTarget:self action:@selector(clickShadowView) forControlEvents:UIControlEventTouchUpInside];
    self.shadowView.adjustsImageWhenHighlighted = NO; // 取消高亮
    [self addSubview:self.shadowView];
}

/** 弹出动画 */
- (void)show {
    self.shadowView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:kETPopAnimationDuration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.shadowView.alpha = 1.0f;
        self.contentView.transform = CGAffineTransformIdentity;
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

#pragma mark -- 无标题无按钮 --

+ (ETPopView *)popViewWithTip:(NSString *)tip {
    ETPopView *popView = [[ETPopView alloc] initWithFrame:ETWindow.bounds];
    [popView setupSubviewsWithTip:tip];
    [ETWindow addSubview:popView];
    [popView show];
    return popView;
}

- (void)setupSubviewsWithTip:(NSString *)tip {
    
    // 根据字体和宽度计算文本高度
    CGFloat tip_height = [UILabel text:tip heightWithFontSize:14 width:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    CGFloat contentView_height = tip_height + 40 + kETTipViewWithTopAndBottom;
    CGFloat tipView_height = tip_height + 40;

    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.equalTo(self.shadowView.mas_width).multipliedBy(kETWindowWidthScale);
        make.height.equalTo(@(contentView_height));
    }];

    UIView *contentView_shadow = [[UIView alloc] init];
    contentView_shadow.layer.cornerRadius = 10;
    contentView_shadow.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView_shadow];
    [contentView_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];

    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ETPopView_bg"]];
    [contentView_shadow addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@-191);
    }];
    
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.layer.cornerRadius = 10;
    [self.contentView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(self.contentView).with.offset(-kETTipViewWithLeftAndRight);
        make.height.equalTo(@(tipView_height));
    }];
    tipView.layer.shadowColor = [UIColor blackColor].CGColor;
    tipView.layer.shadowOpacity = 0.07;
    tipView.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self.tipLabel setText:tip lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 25, 20, 25);
    [tipView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipView).with.insets(padding);
    }];
    
}

#pragma mark -- 有标题有关闭按钮 --

+ (ETPopView *)popViewWithTitle:(NSString *)title Tip:(NSString *)tip {
    ETPopView *popView = [[ETPopView alloc] initWithFrame:ETWindow.bounds];
    [popView setupSubviewsWithTitle:title Tip:tip];
    [ETWindow addSubview:popView];
    [popView show];
    return popView;
}

- (void)setupSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip {
    
    CGFloat tip_height = [UILabel text:tip heightWithFontSize:14 width:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    CGFloat title_height = [title jk_heightWithFont:[UIFont systemFontOfSize:kETTitleFontOfSize] constrainedToWidth:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom];
    CGFloat contentView_height = tip_height + 40 + 20 + title_height + kETTipViewWithTopAndBottom + 25 + 50;
    CGFloat tipView_height = tip_height + 40;
    
    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.equalTo(self.shadowView.mas_width).multipliedBy(kETWindowWidthScale);
        make.height.equalTo(@(contentView_height));
    }];
    
    UIView *contentView_shadow = [[UIView alloc] init];
    contentView_shadow.layer.cornerRadius = 10;
    contentView_shadow.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView_shadow];
    [contentView_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ETPopView_bg"]];
    [contentView_shadow addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@-123);
    }];
    
    self.titleLabel.text = title;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(20);
    }];
    
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.layer.cornerRadius = 10;
    [self.contentView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(25);
        make.width.equalTo(self.contentView).with.offset(-kETTipViewWithLeftAndRight);
        make.height.equalTo(@(tipView_height));
    }];
    tipView.layer.shadowColor = [UIColor blackColor].CGColor;
    tipView.layer.shadowOpacity = 0.07;
    tipView.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self.tipLabel setText:tip lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 25, 20, 25);
    [tipView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipView).with.insets(padding);
    }];
    
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setImage:[UIImage imageNamed:@"ETPopView_close"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(tipView.mas_bottom).with.offset(25);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
}

#pragma mark -- 有标题有确认和关闭按钮 --

+ (ETPopView *)popViewWithDelegate:(id)delegate Title:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle {
    ETPopView *popView = [[ETPopView alloc] initWithFrame:ETWindow.bounds];
    popView.delegate = delegate;
    [popView setupSubviewsWithTitle:title Tip:tip SureBtnTitle:sureBtnTitle];
    [ETWindow addSubview:popView];
    [popView show];
    return popView;
}

- (void)setupSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle {
    
    CGFloat tip_height = [UILabel text:tip heightWithFontSize:14 width:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    CGFloat title_height = [title jk_heightWithFont:[UIFont systemFontOfSize:kETTitleFontOfSize] constrainedToWidth:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom];
    CGFloat contentView_height = tip_height + 40 + 20 + title_height + kETTipViewWithTopAndBottom + 25 + 50;
    CGFloat tipView_height = tip_height + 40;
    
    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.equalTo(self.shadowView.mas_width).multipliedBy(kETWindowWidthScale);
        make.height.equalTo(@(contentView_height));
    }];
    
    UIView *contentView_shadow = [[UIView alloc] init];
    contentView_shadow.layer.cornerRadius = 10;
    contentView_shadow.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView_shadow];
    [contentView_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ETPopView_bg"]];
    [contentView_shadow addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@-123);
    }];
    
    self.titleLabel.text = title;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(20);
    }];
    
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.layer.cornerRadius = 10;
    [self.contentView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(25);
        make.width.equalTo(self.contentView).with.offset(-kETTipViewWithLeftAndRight);
        make.height.equalTo(@(tipView_height));
    }];
    tipView.layer.shadowColor = [UIColor blackColor].CGColor;
    tipView.layer.shadowOpacity = 0.07;
    tipView.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self.tipLabel setText:tip lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 25, 20, 25);
    [tipView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipView).with.insets(padding);
    }];
    
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setImage:[UIImage imageNamed:@"ETPopView_close"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom).with.offset(25);
        make.left.equalTo(tipView.mas_left);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeBtn);
        make.right.equalTo(tipView.mas_right);
        make.left.equalTo(self.closeBtn.mas_right).with.offset(13);
        make.height.equalTo(self.closeBtn);
    }];
    
}

#pragma mark -- 有标题有确认和取消按钮 --

+ (ETPopView *)popViewWithDelegate:(id)delegate Title:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle {
    ETPopView *popView = [[ETPopView alloc] initWithFrame:ETWindow.bounds];
    popView.delegate = delegate;
    [popView setupSubviewsWithTitle:title Tip:tip SureBtnTitle:sureBtnTitle CancelBtnTitle:cancelBtnTitle];
    [ETWindow addSubview:popView];
    [popView show];
    return popView;
}

- (void)setupSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle {
    
    CGFloat tip_height = [UILabel text:tip heightWithFontSize:14 width:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    CGFloat title_height = [title jk_heightWithFont:[UIFont systemFontOfSize:kETTitleFontOfSize] constrainedToWidth:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom];
    CGFloat contentView_height = tip_height + 40 + 20 + title_height + kETTipViewWithTopAndBottom + 25 + 50;
    CGFloat tipView_height = tip_height + 40;
    
    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.equalTo(self.shadowView.mas_width).multipliedBy(kETWindowWidthScale);
        make.height.equalTo(@(contentView_height));
    }];
    
    UIView *contentView_shadow = [[UIView alloc] init];
    contentView_shadow.layer.cornerRadius = 10;
    contentView_shadow.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView_shadow];
    [contentView_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ETPopView_bg"]];
    [contentView_shadow addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@-123);
    }];
    
    self.titleLabel.text = title;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(20);
    }];
    
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.layer.cornerRadius = 10;
    [self.contentView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(25);
        make.width.equalTo(self.contentView).with.offset(-kETTipViewWithLeftAndRight);
        make.height.equalTo(@(tipView_height));
    }];
    tipView.layer.shadowColor = [UIColor blackColor].CGColor;
    tipView.layer.shadowOpacity = 0.07;
    tipView.layer.shadowOffset = CGSizeMake(0, 2);
    
    [self.tipLabel setText:tip lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 25, 20, 25);
    [tipView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipView).with.insets(padding);
    }];
    
    [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom).with.offset(25);
        make.left.equalTo(tipView.mas_left);
        make.width.equalTo(tipView).multipliedBy(0.47);
        make.height.equalTo(@50);
    }];
    
    [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureBtn);
        make.right.equalTo(tipView.mas_right);
        make.width.equalTo(tipView).multipliedBy(0.47);
        make.height.equalTo(@50);
    }];
    
}

#pragma mark -- 指定宽度比例大小提示框 --

+ (ETPopView *)popCustomizeViewWithDelegate:(id)delegate Title:(NSString *)title Tip:(NSString *)tip ImageURL:(NSString *)imageUrl WidthScale:(CGFloat)widthScale SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle {

    ETPopView *popView = [[ETPopView alloc] initWithFrame:ETWindow.bounds];
    popView.delegate = delegate;
    [popView setupCustomizeSubviewsWithTitle:title Tip:tip ImageURL:imageUrl WidthScale:widthScale SureBtnTitle:sureBtnTitle CancelBtnTitle:cancelBtnTitle];
    [ETWindow addSubview:popView];
    [popView show];
    return popView;
}

- (void)setupCustomizeSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip ImageURL:(NSString *)imageUrl WidthScale:(CGFloat)widthScale SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle {
    
    CGFloat tip_height = [tip isEqualToString:@""] ? self.shadowView.jk_width * widthScale - 2 * kETTipViewWithLeftAndRight :
    [UILabel text:tip heightWithFontSize:14 width:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
    CGFloat title_height = [title jk_heightWithFont:[UIFont systemFontOfSize:kETTitleFontOfSize] constrainedToWidth:self.shadowView.jk_width * kETWindowWidthScale - kETTipViewWithLeftAndRight - kETTipViewWithTopAndBottom];
    CGFloat contentView_height = tip_height + 40 + 20 + title_height + kETTipViewWithTopAndBottom + 25 + 50;
    CGFloat tipView_height = tip_height + 40;
    
    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.equalTo(self.shadowView.mas_width).multipliedBy(widthScale);
        make.height.equalTo(@(contentView_height));
    }];
    
    UIView *contentView_shadow = [[UIView alloc] init];
    contentView_shadow.layer.cornerRadius = 10;
    contentView_shadow.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView_shadow];
    [contentView_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    if (![tip isEqualToString:@""]) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ETPopView_bg"]];
        [contentView_shadow addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(@-123);
        }];
        
        self.titleLabel.text = title;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(20);
        }];
        
        UIView *tipView = [[UIView alloc] init];
        tipView.backgroundColor = [UIColor whiteColor];
        tipView.layer.cornerRadius = 10;
        [self.contentView addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(25);
            make.width.equalTo(self.contentView).with.offset(-kETTipViewWithLeftAndRight);
            make.height.equalTo(@(tipView_height));
        }];
        tipView.layer.shadowColor = [UIColor blackColor].CGColor;
        tipView.layer.shadowOpacity = 0.07;
        tipView.layer.shadowOffset = CGSizeMake(0, 2);
        
        [self.tipLabel setText:tip lineSpacing:kETTipLineSpacing wordSpacing:kETTipWordSpacing];
        UIEdgeInsets padding = UIEdgeInsetsMake(20, 25, 20, 25);
        [tipView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(tipView).with.insets(padding);
        }];
    } else {
        UIImageView *posterImageView = [[UIImageView alloc] init];
        [posterImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [contentView_shadow addSubview:posterImageView];
        [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    
    if ([cancelBtnTitle isEqualToString:@""]) {
        [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
        [self.contentView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-25);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.40);
            make.height.equalTo(@50);
        }];
    } else {
        [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
        [self.contentView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-25);
            make.left.equalTo(self.contentView.mas_left).with.offset(kETTipViewWithLeftAndRight / 2);
            make.width.equalTo(self.contentView).multipliedBy(0.4);
            make.height.equalTo(@50);
        }];
        
        [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
        [self.contentView addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sureBtn);
            make.right.equalTo(self.contentView.mas_right).with.offset(-kETTipViewWithLeftAndRight / 2);
            make.width.equalTo(self.contentView).multipliedBy(0.4);
            make.height.equalTo(@50);
        }];
    }
    
//    [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
//    //    [self.sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.sureBtn];
//    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_bottom).with.offset(-25);
//        make.left.equalTo(self.contentView.mas_left).with.offset(kETTipViewWithLeftAndRight);
//        make.width.equalTo(self.contentView).multipliedBy(0.40);
//        make.height.equalTo(@50);
//    }];
    
//    [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
//    [self.contentView addSubview:self.cancelBtn];
//    self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make
//    }
    
}

- (void)setupCustomizeSubviewsWithImageURL:(NSString *)imageUrl WidthScale:(CGFloat)widthScale AspectRatio:(CGFloat)aspectRatio SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle {
    
    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.equalTo(self.shadowView.mas_width).multipliedBy(widthScale);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(aspectRatio);
    }];
    
    UIView *contentView_shadow = [[UIView alloc] init];
    contentView_shadow.layer.cornerRadius = 10;
    contentView_shadow.layer.masksToBounds = YES;
    [self.contentView addSubview:contentView_shadow];
    [contentView_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    UIImageView *posterImageView = [[UIImageView alloc] init];
    [posterImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [contentView_shadow addSubview:posterImageView];
    [posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    if ([cancelBtnTitle isEqualToString:@""]) {
        [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
        [self.contentView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-25);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.40);
            make.height.equalTo(@50);
        }];
    } else {
        [self.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
        [self.contentView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-25);
            make.left.equalTo(self.contentView.mas_left).with.offset(kETTipViewWithLeftAndRight / 2);
            make.width.equalTo(self.contentView).multipliedBy(0.4);
            make.height.equalTo(@50);
        }];
        
        [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
        [self.contentView addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sureBtn);
            make.right.equalTo(self.contentView.mas_right).with.offset(-kETTipViewWithLeftAndRight / 2);
            make.width.equalTo(self.contentView).multipliedBy(0.4);
            make.height.equalTo(@50);
        }];
    }
}


#pragma mark -- lazyLoad --

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.shadowOpacity = 0.15;
        _contentView.layer.shadowOffset = CGSizeMake(0, 2);
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _titleLabel.layer.shadowOpacity = 0.6;
        _titleLabel.layer.shadowRadius = 1;
        _titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.font = [UIFont systemFontOfSize:kETTitleFontOfSize];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:kETTipFontOfSize];
    }
    return _tipLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.backgroundColor = [UIColor whiteColor];
        _closeBtn.layer.cornerRadius = 25;
        _closeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _closeBtn.layer.shadowOpacity = 0.15;
        _closeBtn.layer.shadowOffset = CGSizeMake(0, 2);
    }
    return _closeBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = [UIColor whiteColor];
        _sureBtn.layer.cornerRadius = 25;
        _sureBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _sureBtn.layer.shadowOpacity = 0.15;
        _sureBtn.layer.shadowOffset = CGSizeMake(0, 2);
        [_sureBtn setTitleColor:ETMinorColor forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kETTipFontOfSize]];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.layer.cornerRadius = 25;
        _cancelBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        _cancelBtn.layer.shadowOpacity = 0.15;
        _cancelBtn.layer.shadowOffset = CGSizeMake(0, 2);
        [_cancelBtn setTitleColor:ETGrayColor forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kETTipFontOfSize]];
    }
    return _cancelBtn;
}

- (void)setShadowClose:(BOOL)shadowClose {
    if (!shadowClose) {
        [self.shadowView removeTarget:self action:@selector(clickShadowView) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -- 代理方法 --

- (void)clickSureBtn {
    if ([self.delegate respondsToSelector:@selector(popViewClickSureBtn)]) {
        [self.delegate popViewClickSureBtn];
    }
    [self close];
}

- (void)clickCancelBtn {
    if ([self.delegate respondsToSelector:@selector(popViewClickCancelBtn)]) {
        [self.delegate popViewClickCancelBtn];
    }
    [self close];
}

- (void)clickShadowView {
    if ([self.delegate respondsToSelector:@selector(popViewClickShadowView)]) {
        [self.delegate popViewClickShadowView];
    }
    [self close];
}

@end
