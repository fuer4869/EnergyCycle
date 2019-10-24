//
//  PK_Project_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/3/30.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 获取pk项目详情 */
@interface PK_Project_Get_Request : ETRequest

- (id)initWithProjectID:(NSInteger)projectID;

@end
