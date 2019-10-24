//
//  Find_Radio_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/6.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 电台列表 不需登录 */
@interface Find_Radio_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
