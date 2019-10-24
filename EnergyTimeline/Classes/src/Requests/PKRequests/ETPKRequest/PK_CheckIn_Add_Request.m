//
//  PK_CheckIn_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_CheckIn_Add_Request.h"

/** 今日签到 */
@implementation PK_CheckIn_Add_Request

- (NSString *)requestUrl {
    return @"ec/v2/CheckIn/CheckIn_Add";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

@end
