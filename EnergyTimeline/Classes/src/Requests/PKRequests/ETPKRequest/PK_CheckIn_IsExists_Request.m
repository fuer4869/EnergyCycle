//
//  PK_CheckIn_IsExists_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_CheckIn_IsExists_Request.h"

/** 判断用户今日是否签到 需登录 */
@implementation PK_CheckIn_IsExists_Request

- (NSString *)requestUrl {
    return @"ec/CheckIn/CheckIn_IsExists";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

@end
