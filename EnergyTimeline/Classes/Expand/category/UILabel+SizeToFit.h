//
//  UILabel+SizeToFit.h
//  能量圈
//
//  Created by 王斌 on 2017/4/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SizeToFit)

/** 设置行间距 */
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

/** 设置字间距 */
- (void)setText:(NSString *)text wordSpacing:(CGFloat)wordSpacing;

/** 设置行间距与字间距 */
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing wordSpacing:(CGFloat)wordSpacing;

/** 计算行高__设置行间距 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

/** 计算行高__设置字间距 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width wordSpacing:(CGFloat)wordSpacing;

/** 计算行高__设置行间距与字间距 */
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing wordSpacing:(CGFloat)wordSpacing;

@end
