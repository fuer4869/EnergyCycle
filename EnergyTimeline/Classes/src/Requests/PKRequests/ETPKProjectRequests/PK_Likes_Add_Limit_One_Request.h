//
//  PK_Likes_Add_Limit_One_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/1/22.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 喜欢(提交上限为1的项目,例如:戒游戏,戒网络小说) */
@interface PK_Likes_Add_Limit_One_Request : ETRequest

- (id)initWithToUserID:(NSInteger)toUserID ProjectID:(NSInteger)projectID;

@end
