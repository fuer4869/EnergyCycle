//
//  NSString+Regex.m
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

/** 字符串是否为纯数字 */
- (BOOL)isVaildDigtal {
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

@end
