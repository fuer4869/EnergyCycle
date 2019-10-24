//
//  NSString+Time.h
//  能量圈
//
//  Created by 王斌 on 2017/6/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)

+ (NSString *)convertMinAndSecWithTime:(NSInteger)time;

+ (NSString *)timeInfoWithDateString:(NSString *)dateString;

@end
