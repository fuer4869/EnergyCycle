//
//  User_UserInfo_Edit_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 修改用户信息 */
@interface User_UserInfo_Edit_Request : ETRequest

- (id)initWithUserID:(NSInteger)userID NickName:(NSString *)nickName UserName:(NSString *)userName Birthday:(NSString *)birthday Gender:(NSInteger)gender Email:(NSString *)email Brief:(NSString *)brief;

@end
