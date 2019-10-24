//
//  ETSlider.m
//  能量圈
//
//  Created by 王斌 on 2018/4/18.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETSlider.h"

@implementation ETSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    // 先调用父类的方法获取正确的bounds, 否则autolayout会失效导致控件位置偏移
    bounds = [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y - 2, bounds.size.width, 4);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
