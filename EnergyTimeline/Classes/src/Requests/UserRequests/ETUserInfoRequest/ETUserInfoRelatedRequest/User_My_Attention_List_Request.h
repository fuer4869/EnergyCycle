//
//  User_My_Attention_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 我关注的 需登录 */
@interface User_My_Attention_List_Request : ETRequest

- (id)initWithToUserID:(NSInteger)toUserID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
