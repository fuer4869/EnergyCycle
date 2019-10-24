//
//  Login_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/4/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Login_Request.h"

/** 登录,三种登录方式 */
@implementation Login_Request {
    NSInteger _loginType;
    
    NSString *_loginName;
    NSInteger _code;
    
    NSString *_openID;
    NSString *_nickName;
    NSString *_profilePicture;
}

- (id)initWithLoginName:(NSString *)loginName Code:(NSInteger)code {
    if (self = [super init]) {
        _loginType = 0;
        _loginName = loginName;
        _code = code;
        _openID = @"";
        _nickName = @"";
        _profilePicture = @"";
    }
    return self;
}

- (id)initWithLoginType:(NSInteger)loginType OpenID:(NSString *)openID NickName:(NSString *)nickName ProfilePicture:(NSString *)profilePicture {
    if (self = [super init]) {
        _loginType = loginType;
        _loginName = @"";
        _code = 0;
        _openID = openID;
        _nickName = nickName;
        _profilePicture = profilePicture;
    }
    return self;
}
//NickName>string      //昵称ProfilePicture

- (NSString *)requestUrl {
    return @"ec/Account/Login";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"loginType":@(_loginType),
             @"loginName":_loginName,
             @"code":@(_code),
             @"openID":_openID,
             @"nickName":_nickName,
             @"profilePicture":_profilePicture};
}


@end
