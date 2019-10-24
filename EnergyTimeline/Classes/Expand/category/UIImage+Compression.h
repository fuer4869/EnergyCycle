//
//  UIImage+Compression.h
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)

+ (UIImage *)compressImage:(UIImage *)image toKilobyte:(NSUInteger)maxLength;

@end