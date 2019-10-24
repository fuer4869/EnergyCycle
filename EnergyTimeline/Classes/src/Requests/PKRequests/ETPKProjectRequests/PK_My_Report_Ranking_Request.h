//
//  PK_My_Report_Ranking_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/12/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 我的项目排名情况 */
@interface PK_My_Report_Ranking_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID;

@end
