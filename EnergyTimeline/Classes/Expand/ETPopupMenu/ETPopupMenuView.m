//
//  MenuView.m
//  MenuAnimation
//
//  Created by 王斌 on 2017/4/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPopupMenuView.h"

/** 弹出时最远距离 */
CGFloat const kETPopupMenuItemFarRadius = 110.0f;
/** 收起时最远距离 */
CGFloat const kETPopupMenuItemNearRadius = 130.0f;
/** 弹出后停止距离 */
CGFloat const kETPopupMenuItemEndRadius = 100.0f;
/** 按钮展开的角度 */
CGFloat const kETPopupMenuItemWholeAngle = M_PI * 0.5;
/** 开始的角度 */
CGFloat const kETPopupMenuItemStartAngle = M_PI * 1.25;
/** 弹出时旋转的度数 */
CGFloat const kETPopupMenuItemExoandRotation = M_PI;
/** 收起时旋转的度数 */
CGFloat const kETPopupMenuItemCloseRotation = M_PI;
/** 中心按钮宽度 */
CGFloat const kETPopupMenuCenterBtnWidth = 40.0f;
/** 动画持续时间 */
CGFloat const kETPopupMenuAnimationDuration = 0.3f;

@interface ETPopupMenuView ()<ETPopupMenuItemDelegate, CAAnimationDelegate>

@property (nonatomic, strong) UIButton *shadowView;

@property (nonatomic, assign) CGFloat centerBtnX;
@property (nonatomic, assign) CGFloat centerBtnY;

@property (nonatomic, strong) ETPopupMenuItem *centerBtn;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign, getter=isExpanded) BOOL expanded;
@property (nonatomic, assign, getter=isAnimation) BOOL animation;

@end

@implementation ETPopupMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.shadowView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shadowView.frame = ETWindow.bounds;
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.shadowView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    // 取消高亮
    self.shadowView.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.shadowView];
}

// 设置菜单按钮
- (void)setupMenuBtn:(UIButton *)menuBtn menuItems:(NSArray *)menuItemsImage {
    
    // 中心按钮
    UIImage *centerImage = menuBtn.currentBackgroundImage;
    ETPopupMenuItem *center = [[ETPopupMenuItem alloc] initWithImage:centerImage highlightedImage:centerImage contentImage:nil contentHighlightedImage:nil];
    self.centerBtn = center;
    self.centerBtn.delegate = self;
    self.centerBtn.jk_width = menuBtn.jk_width;
    self.centerBtn.jk_height = menuBtn.jk_height;
    self.centerBtn.center = self.startPoint;
    [self.shadowView addSubview:self.centerBtn];
    
    // 按钮组
    for (int i = 0; i < menuItemsImage.count; i ++) {
        UIImage *itemImage = [UIImage imageNamed:menuItemsImage[i]];
        ETPopupMenuItem *item = [[ETPopupMenuItem alloc] initWithImage:itemImage highlightedImage:itemImage contentImage:nil contentHighlightedImage:nil];
        item.delegate = self;
        item.tag = i;
        [self.menuItems addObject:item];
    }
}

#pragma mark -- Delegate --

+ (instancetype)showWithDelegate:(id)delegate MenuBtn:(UIButton *)menuBtn MenuItems:(NSArray *)menuItemsImage {
    
    ETPopupMenuView *popupMenuView = [[ETPopupMenuView alloc] initWithFrame:ETWindow.bounds];
    popupMenuView.startPoint = menuBtn.center;
    popupMenuView.centerBtnX = menuBtn.center.x;
    popupMenuView.centerBtnY = menuBtn.center.y;
    popupMenuView.delegate = delegate;
    [ETWindow addSubview:popupMenuView];
    
    [popupMenuView setupMenuBtn:menuBtn menuItems:menuItemsImage];
    [popupMenuView setupMenuItems];

    popupMenuView.expanded = YES;
    
    return popupMenuView;
}

- (void)popupMenuItemTouchesBegan:(ETPopupMenuItem *)item {
    if (self.isAnimation) return;
    
    if (item == self.centerBtn) {
        self.expanded = !self.isExpanded;
        return;
    }
    
    [self blowupWithItem:item];
    
    for (ETPopupMenuItem *otherItem in self.menuItems) {
        if (otherItem.tag == item.tag) {
            continue;
        }
        [self shrinkWithItem:otherItem];
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    self.animation = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.animation = NO;
    if ([[anim valueForKey:@"id"] isEqualToString:@"closeAni"]) {
        [self removeFromSuperview];
    } else if ([[anim valueForKey:@"id"] isEqualToString:@"blowupAni"]) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(popupMenuView:selectedIndex:)]) {
            [self.delegate popupMenuView:self selectedIndex:[[anim valueForKey:@"selectedIndex"] integerValue]];
        }
    }
}

#pragma mark -- Core --

// 设置按钮组的各个位置
- (void)setupMenuItems {
    
    // 每个按钮之间的角度差
    CGFloat gapAngle = kETPopupMenuItemWholeAngle / (self.menuItems.count - 1);
    for (ETPopupMenuItem *item in self.menuItems) {
        
        // item的角度
        CGFloat angle = kETPopupMenuItemStartAngle + item.tag * gapAngle;
        
        // 弹出开始位置
        item.startPoint = CGPointMake(self.centerBtnX, self.centerBtnY);
        
        CGFloat cos = cosf(angle);
        CGFloat sin = sinf(angle);
        
        // 计算弹出时最远位置
        CGPoint farPoint = CGPointMake(self.centerBtnX + kETPopupMenuItemFarRadius * cos,
                                       self.centerBtnY + kETPopupMenuItemFarRadius * sin);
        item.farPoint = farPoint;
        
        // 计算收起时最远位置
        CGPoint nearPoint = CGPointMake(self.centerBtnX + kETPopupMenuItemNearRadius * cos,
                                        self.centerBtnY + kETPopupMenuItemNearRadius * sin);
        item.nearPonint = nearPoint;
        
        // 计算弹出后停止位置
        CGPoint endPoint = CGPointMake(self.centerBtnX + kETPopupMenuItemEndRadius * cos,
                                       self.centerBtnY + kETPopupMenuItemEndRadius * sin);
        item.endPoint = endPoint;
        
        item.jk_width = kETPopupMenuCenterBtnWidth;
        item.jk_height = kETPopupMenuCenterBtnWidth;
        item.center = self.startPoint;
        
        [self.shadowView insertSubview:item belowSubview:self.centerBtn];
        
    }
}

// 弹出
- (void)open {
    for (ETPopupMenuItem *item in self.menuItems) {
        [self expandWithTag:item.tag];
    }
    [self rotate];
}

// 收起
- (void)close {
    for (ETPopupMenuItem *item in self.menuItems) {
        [self closeWithTag:item.tag];
    }
    [self rotate];
}

- (void)rotate {
    CGFloat angle = M_PI_4;
    CAKeyframeAnimation *rotationAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.values = !self.expanded ? @[@0, @(angle)] : @[@(angle), @0];
    rotationAni.duration = kETPopupMenuAnimationDuration / 2;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = NO;
    [self.centerBtn.layer addAnimation:rotationAni forKey:@"centerAni"];
}

// 弹出动画
- (void)expandWithTag:(NSInteger)tag {
    ETPopupMenuItem *item = self.menuItems[tag];
    
    CAKeyframeAnimation *rotationAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.values = @[@(kETPopupMenuItemExoandRotation * 2), @0.0f];
    
    CAKeyframeAnimation *postionAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.centerBtnX, self.centerBtnY);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPonint.x, item.nearPonint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    postionAni.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[rotationAni, postionAni];
    group.duration = kETPopupMenuAnimationDuration;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    [group setValue:@"expandAni" forKey:@"id"];
    [item.layer addAnimation:group forKey:@"expandAni"];
    
    item.center = item.endPoint;
}

// 收起动画
- (void)closeWithTag:(NSInteger)tag {
    ETPopupMenuItem *item = self.menuItems[tag];
    
    CAKeyframeAnimation *rotationAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.values = @[@0, @(kETPopupMenuItemCloseRotation * 2), @0];
    
    CAKeyframeAnimation *postionAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    postionAni.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[rotationAni, postionAni];
    group.duration = kETPopupMenuAnimationDuration;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    [group setValue:@"closeAni" forKey:@"id"];
    
    [item.layer addAnimation:group forKey:@"closeAni"];
    
    item.center = item.startPoint;
}

- (void)blowupWithItem:(ETPopupMenuItem *)item {
    CAKeyframeAnimation *positionAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAni.values = @[[NSValue valueWithCGPoint:item.center]];
    positionAni.keyTimes = @[@.3f];
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAni.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAni.toValue = @[@0.0f];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[positionAni, scaleAni, opacityAni];
    group.duration = kETPopupMenuAnimationDuration;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [group setValue:@"blowupAni" forKey:@"id"];
    [group setValue:@(item.tag) forKey:@"selectedIndex"];
    
    [item.layer addAnimation:group forKey:@"blowupAni"];
    
    item.center = item.startPoint;
}

- (void)shrinkWithItem:(ETPopupMenuItem *)item {
    CAKeyframeAnimation *positionAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAni.values = @[[NSValue valueWithCGPoint:item.center]];
    positionAni.keyTimes = @[@.3f];
    
    CABasicAnimation *scaleAni = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAni.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAni.toValue = @[@0.0f];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[positionAni, scaleAni, opacityAni];
    group.duration = kETPopupMenuAnimationDuration;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    [group setValue:@"shrinkAni" forKey:@"id"];
    
    [item.layer addAnimation:group forKey:@"shrinkAni"];
    
    item.center = item.startPoint;
}

#pragma mark -- Setter Getter --

- (ETPopupMenuItem *)centerBtn {
    if (!_centerBtn) {
        _centerBtn.delegate = self;
    }
    return _centerBtn;
}

- (NSMutableArray *)menuItems {
    if (!_menuItems) {
        _menuItems = [NSMutableArray array];
    }
    return _menuItems;
}

- (void)setExpanded:(BOOL)expanded {
    if (self.isAnimation) return;
    
    if (expanded) {
        [self open];
    } else {
        [self close];
    }
    
    _expanded = expanded;
}


@end
