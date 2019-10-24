//
//  Logout_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Logout_Request.h"

/** 退出登录 */
@implementation Logout_Request

- (NSString *)requestUrl {
    return @"ec/Account/Logout";
}

@end
