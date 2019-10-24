//
//  PK_Report_Rank_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 每日PK排行榜 需登录 */
@interface PK_Report_Rank_List_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
