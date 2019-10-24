//
//  ETHelpManager.h
//  能量圈
//
//  Created by 王斌 on 2017/5/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETHelpManager : NSObject

/** 单例 */
+ (id)sharedInstance;

/** 获取登录用户ID */
- (NSString *)readUserID;
/** 获取验证码权限密文 */
- (NSString *)readHashCode;
/** 获取登录用户请求密文 */
- (NSString *)readTicket;
/** 获取登录用户权限 */
- (NSString *)readRole;
/** 获取登录用户昵称 */
- (NSString *)readNickName;
/** 登录状态 */
- (BOOL)loginStatus;

@end
