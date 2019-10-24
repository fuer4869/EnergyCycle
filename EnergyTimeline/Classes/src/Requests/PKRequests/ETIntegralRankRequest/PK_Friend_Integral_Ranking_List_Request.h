//
//  PK_Friend_Integral_Ranking_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/12/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 积分排行榜 -- 好友排行 需登录 */
@interface PK_Friend_Integral_Ranking_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
