//
//  UIColor+GradientColors.m
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "UIColor+GradientColors.h"

@implementation UIColor (GradientColors)

+ (void)setGradientImage:(UIImage *)gradientImage {
    
    objc_setAssociatedObject(self, @selector(gradientImage), gradientImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIColor *)colorWithETGradientStyle:(ETGradientStyle)gradientStyle withFrame:(CGRect)frame andColors:(NSArray *)colors {

    //Create our background gradient layer
    CAGradientLayer *backgroundGradientLayer = [CAGradientLayer layer];
    
    //Set the frame to our object's bounds
    backgroundGradientLayer.frame = frame;
    
    //To simplfy formatting, we'll iterate through our colors array and create a mutable array with their CG counterparts
    NSMutableArray *cgColors = [[NSMutableArray alloc] init];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)[color CGColor]];
    }
    
    //Set out gradient's colors
    backgroundGradientLayer.colors = cgColors;
    
    //Specify the direction our gradient will take
    
    switch (gradientStyle) {
        case ETGradientStyleTopLeftToBottomRight: {
            [backgroundGradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
            [backgroundGradientLayer setEndPoint:CGPointMake(1.0, 1.0)];
        }
            break;
        case ETGradientStyleTopRightToBottomLeft: {
            [backgroundGradientLayer setStartPoint:CGPointMake(1.0, 0.0)];
            [backgroundGradientLayer setEndPoint:CGPointMake(0.0, 1.0)];
        }
            break;
        case ETGradientStyleBottomLeftToTopRight: {
            [backgroundGradientLayer setStartPoint:CGPointMake(0.0, 1.0)];
            [backgroundGradientLayer setEndPoint:CGPointMake(1.0, 0.0)];
        }
            break;
        case ETGradientStyleBottomRightToTopLeft: {
            [backgroundGradientLayer setStartPoint:CGPointMake(1.0, 1.0)];
            [backgroundGradientLayer setEndPoint:CGPointMake(0.0, 0.0)];
        }
            break;
    }
    
    //Convert our CALayer to a UIImage object
    UIGraphicsBeginImageContextWithOptions(backgroundGradientLayer.bounds.size,NO, [UIScreen mainScreen].scale);
    [backgroundGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setGradientImage:backgroundColorImage];
    return [UIColor colorWithPatternImage:backgroundColorImage];
    
}

@end
