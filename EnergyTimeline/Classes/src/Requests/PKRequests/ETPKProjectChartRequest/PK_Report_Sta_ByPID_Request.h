//
//  PK_Report_Sta_ByPID_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/8/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 根据项目ID获取汇报详情_需要时间参数的列表 */
@interface PK_Report_Sta_ByPID_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID UserID:(NSInteger)userID StartDate:(NSString *)startDate EndDate:(NSString *)endDate;

@end
