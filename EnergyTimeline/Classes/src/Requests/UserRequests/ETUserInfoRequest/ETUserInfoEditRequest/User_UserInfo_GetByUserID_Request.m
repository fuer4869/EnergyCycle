//
//  User_UserInfo_GetByUserID_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_UserInfo_GetByUserID_Request.h"

/** 根据UserID查询用户信息,查询自己不用传值 需登录 */
@implementation User_UserInfo_GetByUserID_Request {
    NSInteger _userID;
}

- (id)initWithUserID:(NSInteger)userID {
    if (self = [super init]) {
        _userID = userID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/UserInfo_GetByUserID";
}

- (id)requestArgument {
    return @{@"ToUserID":@(_userID)};
}

@end
