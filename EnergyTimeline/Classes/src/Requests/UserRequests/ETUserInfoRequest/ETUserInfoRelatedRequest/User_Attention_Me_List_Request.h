//
//  User_Attention_Me_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 关注我的 需登录 */
typedef enum : NSUInteger {
    ETAllFans = 0,
    ETNewFans,
} ETFans;

@interface User_Attention_Me_List_Request : ETRequest

- (id)initWithType:(ETFans)type ToUserID:(NSInteger)toUserID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
