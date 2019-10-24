//
//  Message_User_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 用户消息列表(最近联系人) */
@interface Message_User_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
