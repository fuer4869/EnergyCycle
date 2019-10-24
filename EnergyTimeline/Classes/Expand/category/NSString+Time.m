//
//  NSString+Time.m
//  能量圈
//
//  Created by 王斌 on 2017/6/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

+ (NSString *)convertMinAndSecWithTime:(NSInteger)time {
    NSInteger min = time / 60;
    NSInteger sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%ld",(long)min] : [NSString stringWithFormat:@"0%ld", (long)min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%ld",(long)sec] : [NSString stringWithFormat:@"0%ld", (long)sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@", minStr, secStr];
    return timeStr;
}

+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSDate *date = [NSDate jk_dateWithString:dateString format:[NSDate jk_ymdHmsFormat]];
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
//    int month = (int)([curDate jk_month] - [date jk_month]);
//    int year = (int)([curDate jk_year] - [date jk_year]);
//    int day = (int)([curDate jk_day] - [date jk_day]);
    
    NSTimeInterval retTime = 1.0;
    if (time < 3600) {
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    } else if (time < 3600 * 24) {
        retTime = time / 3600;
        retTime = retTime < 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    } else if (time < 3600 * 24 * 30) {
        retTime = time / (3600 * 24);
        retTime = retTime < 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f天前", retTime];
    } else {
        return [NSDate jk_formatYMD:date];
    }
}

@end
