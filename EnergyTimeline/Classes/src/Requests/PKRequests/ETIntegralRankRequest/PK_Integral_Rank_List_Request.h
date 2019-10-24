//
//  PK_Integral_Rank_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 积分排行榜 -- 世界排行 需登录 */
@interface PK_Integral_Rank_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
