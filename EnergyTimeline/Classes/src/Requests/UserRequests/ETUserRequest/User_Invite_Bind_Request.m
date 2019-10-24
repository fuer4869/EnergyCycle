//
//  User_Invite_Bind_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/2/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "User_Invite_Bind_Request.h"

@implementation User_Invite_Bind_Request {
    NSString *_inviteCode;
}

- (id)initWithInviteCode:(NSString *)inviteCode {
    if (self = [super init]) {
        _inviteCode = inviteCode;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypeGet;
}

- (NSString *)requestUrl {
    return @"ec/user/Invite_Bind";
}

- (id)requestArgument {
    return @{@"InviteCode" : _inviteCode};
}

@end
