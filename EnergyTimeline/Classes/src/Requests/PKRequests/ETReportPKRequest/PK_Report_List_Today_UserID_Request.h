//
//  PK_Report_List_Today_UserID_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/10/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 根据UserID获取今日汇报 需登录 */
@interface PK_Report_List_Today_UserID_Request : ETRequest

- (id)initWithUserID:(NSInteger)userID;

@end
