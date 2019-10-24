//
//  PK_Report_Record_Project_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/12/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 回顾PK记录 需登录 */
@interface PK_Report_Record_Project_List_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
