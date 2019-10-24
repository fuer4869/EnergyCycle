//
//  ETHelpManager.m
//  能量圈
//
//  Created by 王斌 on 2017/5/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHelpManager.h"

@implementation ETHelpManager

/** 单例 */
+ (id)sharedInstance {
    static ETHelpManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ETHelpManager alloc] init];
    });
    return manager;
}

/** 获取登录用户ID */
- (NSString *)readUserID {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    if (userID == nil || [userID isKindOfClass:[NSNull class]] || [userID isEqual:[NSNull null]]) {
        userID = @"";
    }
    return userID;
}

/** 获取验证码权限密文 */
- (NSString *)readHashCode {
    NSString *hashCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"HASHCODE"];
    if (hashCode == nil || [hashCode isKindOfClass:[NSNull class]] || [hashCode isEqual:[NSNull null]]) {
        hashCode = @"";
    }
    return hashCode;
}

/** 获取登录用户请求密文 */
- (NSString *)readTicket {
    NSString *ticket = [[NSUserDefaults standardUserDefaults] objectForKey:@"TICKET"];
    if (ticket == nil || [ticket isKindOfClass:[NSNull class]] || [ticket isEqual:[NSNull null]]) {
        ticket = @"";
    }
    return ticket;
}
/** 获取登录用户权限 */
- (NSString *)readRole {
    NSString *role = [[NSUserDefaults standardUserDefaults] objectForKey:@"ROLE"];
    if (role == nil || [role isKindOfClass:[NSNull class]] || [role isEqual:[NSNull null]]) {
        role = @"";
    }
    return role;
}

/** 获取登录用户昵称 */
- (NSString *)readNickName {
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"NICKNAME"];
    if (nickName == nil || [nickName isKindOfClass:[NSNull class]] || [nickName isEqual:[NSNull null]]) {
        nickName = @"";
    }
    return nickName;
    
}

/** 登录状态 */
- (BOOL)loginStatus {
    return [[self readUserID] isEqualToString:@""] ? NO : YES;
}

@end
