//
//  PK_Target_ADD_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

@interface PK_Target_ADD_Request : ETRequest

- (id)initWithStartDate:(NSString *)startDate EndDate:(NSString *)endDate ProjectID:(NSInteger)projectID ReportNum:(NSInteger)reportNum;

@end
