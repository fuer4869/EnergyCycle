//
//  PK_ReportProject_Del_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/1/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 删除项目 */
@interface PK_ReportProject_Del_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID;

@end
