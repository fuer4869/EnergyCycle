//
//  UITabBar+Badge.m
//  能量圈
//
//  Created by 王斌 on 2017/10/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarItemNums 5.0

@implementation UITabBar (Badge)

- (void)showBadgeItemOnIndex:(NSInteger)index {
    [self removeBadgeItemOnIndex:index];
    
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 88 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    CGFloat percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeItemOnIndex:(NSInteger)index {
    [self removeBadgeItemOnIndex:index];
}

- (void)removeBadgeItemOnIndex:(NSInteger)index {
    for (UIView *subView in self.subviews) {
        if (subView.tag == 88 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
