//
//  PK_Report_List_Today_UserID_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/10/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Report_List_Today_UserID_Request.h"

/** 根据UserID获取今日汇报 需登录 */
@implementation PK_Report_List_Today_UserID_Request {
    NSInteger _userID;
}

- (id)initWithUserID:(NSInteger)userID {
    if (self = [super init]) {
        _userID = userID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/Report_List_Today_UserID";
}

- (id)requestArgument {
    return @{@"UserID" : @(_userID)};
}

@end
