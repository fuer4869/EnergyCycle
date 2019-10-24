//
//  PK_MyCheckIn_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_MyCheckIn_Get_Request.h"

/** 我的签到统计 需登录 */
@implementation PK_MyCheckIn_Get_Request

- (NSString *)requestUrl {
    return @"ec/CheckIn/MyCheckIn_Get";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

@end
