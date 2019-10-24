//
//  PK_Report_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 汇报PK项目 */
@interface PK_Report_Add_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID ReportNum:(NSInteger)reportNum FileIDs:(NSString *)fileIDs Is_Sync:(NSString *)is_Sync;

@end
