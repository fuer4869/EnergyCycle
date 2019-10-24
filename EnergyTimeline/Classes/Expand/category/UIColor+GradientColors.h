//
//  UIColor+GradientColors.h
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GradientColors)

typedef enum : NSUInteger {
    ETGradientStyleTopLeftToBottomRight = 1,
    ETGradientStyleTopRightToBottomLeft,
    ETGradientStyleBottomLeftToTopRight,
    ETGradientStyleBottomRightToTopLeft
} ETGradientStyle;

+ (UIColor *)colorWithETGradientStyle:(ETGradientStyle)gradientStyle withFrame:(CGRect)frame andColors:(NSArray *)colors;

@end
