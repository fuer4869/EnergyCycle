//
//  PK_MyReport_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 我的汇报信息 需登录 */
@interface PK_MyReport_Get_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID;

@end
