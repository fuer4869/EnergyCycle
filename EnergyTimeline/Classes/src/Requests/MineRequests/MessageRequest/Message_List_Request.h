//
//  Message_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 两个人的消息记录 */
@interface Message_List_Request : ETRequest

- (id)initWithToUserID:(NSInteger)toUserID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
