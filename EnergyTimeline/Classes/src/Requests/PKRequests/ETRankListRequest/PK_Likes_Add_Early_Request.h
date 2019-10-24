//
//  PK_Likes_Add_Early_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/1/22.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 签到列表点赞 */
@interface PK_Likes_Add_Early_Request : ETRequest

- (id)initWithToUserID:(NSInteger)toUserID;

@end
