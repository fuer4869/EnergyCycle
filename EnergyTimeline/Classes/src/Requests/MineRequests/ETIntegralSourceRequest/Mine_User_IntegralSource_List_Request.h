//
//  Mine_User_IntegralSource_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 积分记录 需登录 */
@interface Mine_User_IntegralSource_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
