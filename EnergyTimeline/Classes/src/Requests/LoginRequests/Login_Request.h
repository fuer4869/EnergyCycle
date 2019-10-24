//
//  Login_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/4/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 登录,三种登录方式 */
@interface Login_Request : ETRequest

- (id)initWithLoginName:(NSString *)loginName Code:(NSInteger)code;

- (id)initWithLoginType:(NSInteger)loginType OpenID:(NSString *)openID NickName:(NSString *)nickName ProfilePicture:(NSString *)profilePicture;

@end
