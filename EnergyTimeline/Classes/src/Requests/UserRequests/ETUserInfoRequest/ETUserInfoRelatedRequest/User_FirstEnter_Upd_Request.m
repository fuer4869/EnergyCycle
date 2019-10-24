//
//  User_FirstEnter_Upd_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/11/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_FirstEnter_Upd_Request.h"

/** 用户所有功能提醒_更新 */
@implementation User_FirstEnter_Upd_Request {
    NSString *_str;
}

- (id)initWithStr:(NSString *)str {
    if (self = [super init]) {
        _str = str;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/FirstEnter_Upd";
}

- (id)requestArgument {
    return @{@"str":_str};
}

@end
