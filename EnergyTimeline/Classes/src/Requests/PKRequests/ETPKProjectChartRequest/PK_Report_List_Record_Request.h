//
//  PK_Report_List_Record_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/8/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 根据项目ID获取汇报详情_获取列表 */
@interface PK_Report_List_Record_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID UserID:(NSInteger)userID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;


@end
