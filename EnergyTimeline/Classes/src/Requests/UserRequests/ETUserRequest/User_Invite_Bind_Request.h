//
//  User_Invite_Bind_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/2/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

@interface User_Invite_Bind_Request : ETRequest

- (id)initWithInviteCode:(NSString *)inviteCode;

@end