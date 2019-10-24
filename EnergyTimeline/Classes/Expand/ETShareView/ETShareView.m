//
//  ETShareView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETShareView.h"
#import "Masonry.h"

/** qq图标 */
static NSString * const kETShareImg_qq = @"share_qq_round";
/** qq空间 */
static NSString * const kETShareImg_qzone = @"share_qzone_round";
/** 新浪微博图标 */
static NSString * const kETShareImg_sinaWeibo = @"share_sinaWeibo_round";
/** 微信图标 */
static NSString * const kETShareImg_wechatSession = @"share_wechatSession_round";
/** 微信朋友圈图标 */
static NSString * const kETShareImg_wechatTimeline = @"share_wechatTimeline_round";
/** 关闭按钮图标 */
static NSString * const kETCloseImg = @"ETPopView_close";
/** 关闭按钮图标(大) */
static NSString * const kETCloseLargeImg = @"ETPopView_close_large";

/** 阴影层不透明度 */
static CGFloat const kETShadowAlpha = 0.3;


@interface ETShareView ()

/** 阴影层 */
@property (nonatomic, strong) UIButton *shadowView;
/** 弹框内容视图 */
@property (nonatomic, strong) UIView *contentView;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 提醒图片 */
@property (nonatomic, strong) UIImageView *hintImageView;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;

/** 分享结束后是否直接关闭视图 */
@property (nonatomic, assign) BOOL shareEndClose;

/** qq分享按钮 */
@property (nonatomic, strong) UIButton *qqBtn;
/** qq空间分享按钮 */
@property (nonatomic, strong) UIButton *qzoneBtn;
/** 新浪微博分享按钮 */
@property (nonatomic, strong) UIButton *sinaWeiboBtn;
/** 微信分享按钮 */
@property (nonatomic, strong) UIButton *wechatSessionBtn;
/** 微信朋友圈分享按钮 */
@property (nonatomic, strong) UIButton *wechatTimelineBtn;

@end

@implementation ETShareView

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
    self.shadowView.adjustsImageWhenHighlighted = NO; // 取消高亮
    [self addSubview:self.shadowView];
}

- (void)show {
    self.shadowView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.shadowView.alpha = 1.0f;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)close {
    if ([self.delegate respondsToSelector:@selector(shareViewClose)]) {
        [self.delegate shareViewClose];
    }
    [UIView animateWithDuration:0.5
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

#pragma mark -- 全屏分享 --

+ (ETShareView *)shareViewWithFullScreenWithDelegate:(id)delegate {
    ETShareView *shareView = [[ETShareView alloc] initWithFrame:ETWindow.bounds];
    shareView.delegate = delegate;
    shareView.shareEndClose = NO;
    [shareView shareViewWithFullScreen];
    [ETWindow addSubview:shareView];
    [shareView show];
    return shareView;
}

- (void)shareViewWithFullScreen {
    WS(weakSelf)
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = ETMainBgColor;
    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.shadowView);
    }];
    
    self.hintImageView = [[UIImageView alloc] init];
    [self.hintImageView setImage:[UIImage imageNamed:@"release_success_green"]];
    [self.contentView addSubview:self.hintImageView];
    [self.hintImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).with.offset(120);
        make.centerX.equalTo(weakSelf.contentView);
    }];
    
    NSInteger padding = 15;
    
    [self.contentView addSubview:self.wechatTimelineBtn];
    [self.contentView addSubview:self.wechatSessionBtn];
    [self.contentView addSubview:self.sinaWeiboBtn];
    [self.contentView addSubview:self.qqBtn];
    [self.contentView addSubview:self.qzoneBtn];
    
    UILabel *wechatTimelineLabel = [self createLabelWithlTitle:@"朋友圈"];
    wechatTimelineLabel.textColor = ETWhiteColor;
    [self.contentView addSubview:wechatTimelineLabel];
    
    UILabel *wechatSessionLabel = [self createLabelWithlTitle:@"微信好友"];
    wechatSessionLabel.textColor = ETWhiteColor;
    [self.contentView addSubview:wechatSessionLabel];
    
    UILabel *sinaWeiboLabel = [self createLabelWithlTitle:@"微博"];
    sinaWeiboLabel.textColor = ETWhiteColor;
    [self.contentView addSubview:sinaWeiboLabel];
    
    UILabel *qqLabel = [self createLabelWithlTitle:@"QQ"];
    qqLabel.textColor = ETWhiteColor;
    [self.contentView addSubview:qqLabel];
    
    UILabel *qzoneLabel = [self createLabelWithlTitle:@"QQ空间"];
    qzoneLabel.textColor = ETWhiteColor;
    [self.contentView addSubview:qzoneLabel];

    [@[self.wechatTimelineBtn, self.wechatSessionBtn, self.sinaWeiboBtn, self.qqBtn, self.qzoneBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    
    [@[self.wechatTimelineBtn, self.wechatSessionBtn, self.sinaWeiboBtn, self.qqBtn, self.qzoneBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-170);
        make.height.mas_equalTo(self.qzoneBtn.mas_height);
    }];
    
    [@[wechatTimelineLabel, wechatSessionLabel, sinaWeiboLabel, qqLabel, qzoneLabel] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    
    [@[wechatTimelineLabel, wechatSessionLabel, sinaWeiboLabel, qqLabel, qzoneLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatTimelineBtn.mas_bottom).offset(1);
        make.height.mas_equalTo(qzoneLabel.mas_height);
    }];
    
    self.closeBtn = [self createShareBtnWithImage:kETCloseLargeImg];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.top.equalTo(qzoneLabel.mas_bottom);
        make.bottom.equalTo(@0);
    }];
    
}

#pragma mark -- 底部分享框 -- 

+ (ETShareView *)shareViewWithBottomWithDelegate:(id)delegate {
    ETShareView *shareView = [[ETShareView alloc] initWithFrame:ETWindow.bounds];
    shareView.delegate = delegate;
    shareView.shareEndClose = YES;
    [shareView shareViewWithBottom];
    [ETWindow addSubview:shareView];
    [shareView show];
    return shareView;
}

- (void)shareViewWithBottom {
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 0.15;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 2);
    [self.shadowView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.shadowView).multipliedBy(0.35);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-20);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"分享";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@15);
        make.top.equalTo(@30);
    }];
    
    UIImageView *topDashed = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.shadowView.jk_width, 1)];
    [self.contentView addSubview:topDashed];
    [self drawDashed:topDashed];
    [topDashed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(25);
        make.height.equalTo(@1);
    }];
    
    NSInteger padding = 20;
    
    [self.contentView addSubview:self.wechatTimelineBtn];
    [self.contentView addSubview:self.wechatSessionBtn];
    [self.contentView addSubview:self.sinaWeiboBtn];
    [self.contentView addSubview:self.qzoneBtn];
    
    UILabel *wechatTimelineLabel = [self createLabelWithlTitle:@"朋友圈"];
    [self.contentView addSubview:wechatTimelineLabel];
    
    UILabel *wechatSessionLabel = [self createLabelWithlTitle:@"微信好友"];
    [self.contentView addSubview:wechatSessionLabel];
    
    UILabel *sinaWeiboLabel = [self createLabelWithlTitle:@"微博"];
    [self.contentView addSubview:sinaWeiboLabel];
    
    UILabel *qzoneLabel = [self createLabelWithlTitle:@"QQ空间"];
    [self.contentView addSubview:qzoneLabel];

    [@[self.wechatTimelineBtn, self.wechatSessionBtn, self.sinaWeiboBtn, self.qzoneBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    
    [@[self.wechatTimelineBtn, self.wechatSessionBtn, self.sinaWeiboBtn, self.qzoneBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topDashed.mas_bottom).offset(15);
        make.height.mas_equalTo(self.qzoneBtn.mas_height);
    }];
    
    [@[wechatTimelineLabel, wechatSessionLabel, sinaWeiboLabel, qzoneLabel] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    
    [@[wechatTimelineLabel, wechatSessionLabel, sinaWeiboLabel, qzoneLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatTimelineBtn.mas_bottom).offset(1);
        make.height.mas_equalTo(qzoneLabel.mas_height);
    }];
    
    UIImageView *bottomDashed = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.shadowView.jk_width, 1)];
    [self.contentView addSubview:bottomDashed];
    [self drawDashed:bottomDashed];
    [bottomDashed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(qzoneLabel.mas_bottom).with.offset(15);
        make.height.equalTo(@1);
    }];
    
    self.closeBtn = [self createShareBtnWithImage:kETCloseImg];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.top.equalTo(bottomDashed.mas_bottom);
        make.bottom.equalTo(@0);
    }];

}

- (UIButton *)createShareBtnWithImage:(NSString *)image{
    UIButton *button = [[UIButton alloc] init];
    button.userInteractionEnabled = YES;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return button;
}

- (UILabel *)createLabelWithlTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = ETGrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    return label;
}

#pragma mark -- 绘制虚线方法 --

/** 添加虚线__CAShapeLayer */
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/** 添加虚线__UIImageView */
- (void)drawDashed:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.frame.size); //参数size为新创建的位图上下文的大小
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare); //设置线段收尾样式
    
    CGFloat length[] = {2,2}; // 线的宽度，间隔宽度
    CGContextRef line = UIGraphicsGetCurrentContext(); //设置上下文
    CGContextSetStrokeColorWithColor(line, ETGrayColor.CGColor);
    CGContextSetLineWidth(line, 1); //设置线粗细
    CGContextSetLineDash(line, 0, length, 2);//画虚线
    CGContextMoveToPoint(line, 0, 1.0); //开始画线
    CGContextAddLineToPoint(line, imageView.frame.size.width, 1);//画直线
    CGContextStrokePath(line); //指定矩形线
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark -- lazyLoad --

- (UIButton *)qqBtn {
    if (!_qqBtn) {
        _qqBtn = [self createShareBtnWithImage:kETShareImg_qq];
        [_qqBtn addTarget:self action:@selector(clickQQBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqBtn;
}

- (UIButton *)qzoneBtn {
    if (!_qzoneBtn) {
        _qzoneBtn = [self createShareBtnWithImage:kETShareImg_qzone];
        [_qzoneBtn addTarget:self action:@selector(clickQzoneBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qzoneBtn;
}

- (UIButton *)sinaWeiboBtn {
    if (!_sinaWeiboBtn) {
        _sinaWeiboBtn = [self createShareBtnWithImage:kETShareImg_sinaWeibo];
        [_sinaWeiboBtn addTarget:self action:@selector(clickSinaWeiboBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sinaWeiboBtn;
}

- (UIButton *)wechatSessionBtn {
    if (!_wechatSessionBtn) {
        _wechatSessionBtn = [self createShareBtnWithImage:kETShareImg_wechatSession];
        [_wechatSessionBtn addTarget:self action:@selector(clickWechatSessionBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatSessionBtn;
}

- (UIButton *)wechatTimelineBtn {
    if (!_wechatTimelineBtn) {
        _wechatTimelineBtn = [self createShareBtnWithImage:kETShareImg_wechatTimeline];
        [_wechatTimelineBtn addTarget:self action:@selector(clickWechatTimelineBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatTimelineBtn;
}

#pragma mark -- 代理方法 --

- (void)clickWechatTimelineBtn {
    if ([self.delegate respondsToSelector:@selector(shareViewClickWechatTimelineBtn)]) {
        [self.delegate shareViewClickWechatTimelineBtn];
    }
    if (self.shareEndClose) {
        [self close];
    }
}

- (void)clickWechatSessionBtn {
    if ([self.delegate respondsToSelector:@selector(shareViewClickWechatSessionBtn)]) {
        [self.delegate shareViewClickWechatSessionBtn];
    }
    if (self.shareEndClose) {
        [self close];
    }
}

- (void)clickSinaWeiboBtn {
    if ([self.delegate respondsToSelector:@selector(shareViewClickSinaWeiboBtn)]) {
        [self.delegate shareViewClickSinaWeiboBtn];
    }
    if (self.shareEndClose) {
        [self close];
    }
}

- (void)clickQzoneBtn {
    if ([self.delegate respondsToSelector:@selector(shareViewClickQzoneBtn)]) {
        [self.delegate shareViewClickQzoneBtn];
    }
    if (self.shareEndClose) {
        [self close];
    }
}

- (void)clickQQBtn {
    if ([self.delegate respondsToSelector:@selector(shareViewClickQQBtn)]) {
        [self.delegate shareViewClickQQBtn];
    }
    if (self.shareEndClose) {
        [self close];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
