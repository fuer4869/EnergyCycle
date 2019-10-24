//
//  PK_Project_Clock_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/1/25.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 获取提醒信息 */
@interface PK_Project_Clock_Get_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID;

@end
