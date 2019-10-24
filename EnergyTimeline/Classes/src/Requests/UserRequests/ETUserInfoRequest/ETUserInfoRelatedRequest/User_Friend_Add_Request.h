//
//  User_Friend_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 加/取消关注 */
@interface User_Friend_Add_Request : ETRequest

- (id)initWithFriendUserID:(NSInteger)friendUserID;

@end
