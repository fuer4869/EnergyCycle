//
//  User_My_Friend_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 我的好友 需登录 */
@interface User_My_Friend_List_Request : ETRequest

- (id)initWithSearchKey:(NSString *)searchKey PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
