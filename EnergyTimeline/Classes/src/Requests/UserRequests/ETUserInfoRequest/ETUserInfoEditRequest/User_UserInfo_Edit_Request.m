//
//  User_UserInfo_Edit_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_UserInfo_Edit_Request.h"

/** 修改用户信息 */
@implementation User_UserInfo_Edit_Request {
    NSInteger _userID;
    NSString *_nickName;
    NSString *_userName;
    NSString *_birthday;
    NSInteger _gender;
    NSString *_email;
    NSString *_brief;
}

- (id)initWithUserID:(NSInteger)userID NickName:(NSString *)nickName UserName:(NSString *)userName Birthday:(NSString *)birthday Gender:(NSInteger)gender Email:(NSString *)email Brief:(NSString *)brief {
    if (self = [super init]) {
        _userID = userID;
        _nickName = nickName ? nickName : @"";
        _userName = userName ? userName : @"";
        _birthday = birthday ? birthday : @"";
        _gender = gender;
        _email = email ? email : @"";
        _brief = brief ? brief : @"";
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/UserInfo_Edit";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"UserID":@(_userID),
             @"NickName":_nickName,
             @"UserName":_userName,
             @"Birthday":_birthday,
             @"Gender":@(_gender),
             @"Email":_email,
             @"Brief":_brief};
}

@end
