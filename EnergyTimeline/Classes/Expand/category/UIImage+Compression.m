//
//  UIImage+Compression.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "UIImage+Compression.h"

@implementation UIImage (Compression)

+ (UIImage *)compressImage:(UIImage *)image toKilobyte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
//    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat imageSize = image.size.width * image.size.height / 1024;
    
    if (imageSize > maxLength) {
        CGFloat ratio = maxLength / imageSize;
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width * sqrtf(ratio), image.size.height * sqrtf(ratio)));
        [image drawInRect:CGRectMake(0, 0, image.size.width * sqrtf(ratio), image.size.height * sqrtf(ratio))];
        
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return resultImage;
}

@end
