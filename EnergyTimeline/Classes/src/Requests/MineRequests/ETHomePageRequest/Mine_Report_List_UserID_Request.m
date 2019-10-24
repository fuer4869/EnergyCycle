//
//  Mine_Report_List_UserID_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Mine_Report_List_UserID_Request.h"

/** 根据UserID获取PK记录 需登录 */
@implementation Mine_Report_List_UserID_Request {
    NSInteger _userID;
}

- (id)initWithUserID:(NSInteger)userID {
    if (self = [super init]) {
        _userID = userID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/Report_List_UserID";
}

- (id)requestArgument {
    return @{@"UserID":@(_userID)};
}

@end
