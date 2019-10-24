//
//  User_Friend_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_Friend_Add_Request.h"

/** 加/取消关注 */
@implementation User_Friend_Add_Request {
    NSInteger _friendUserID;
}

- (id)initWithFriendUserID:(NSInteger)friendUserID {
    if (self = [super init]) {
        _friendUserID = friendUserID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/Friend_Add";
}

- (id)requestArgument {
    return @{@"FriendUserID":@(_friendUserID)};
}

@end
