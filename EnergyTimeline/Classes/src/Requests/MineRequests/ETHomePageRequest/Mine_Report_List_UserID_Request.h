//
//  Mine_Report_List_UserID_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 根据UserID获取PK记录 需登录 */
@interface Mine_Report_List_UserID_Request : ETRequest

- (id)initWithUserID:(NSInteger)userID;

@end
