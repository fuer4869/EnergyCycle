//
//  User_Discover_UserInfo_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 发现模块用户搜索 需登录 */
@interface User_Discover_UserInfo_List_Request : ETRequest

- (id)initWithSearchKey:(NSString *)searchKey PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
