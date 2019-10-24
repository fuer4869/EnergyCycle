//
//  PK_CheckIn_Early_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 早起签到排行榜 需登录 */
@interface PK_CheckIn_Early_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
