//
//  HashCode_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/10/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "HashCode_Request.h"

/** 登录前 为登录进行加密(md5 * 2) */
@implementation HashCode_Request

- (NSString *)requestUrl {
    return @"ec/Account/HashCode_Get";
}

@end
