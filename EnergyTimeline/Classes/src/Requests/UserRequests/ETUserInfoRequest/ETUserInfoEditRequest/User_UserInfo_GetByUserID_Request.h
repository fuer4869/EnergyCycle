//
//  User_UserInfo_GetByUserID_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 根据UserID查询用户信息,查询自己不用传值 需登录 */
@interface User_UserInfo_GetByUserID_Request : ETRequest

- (id)initWithUserID:(NSInteger)userID;

@end
