//
//  PK_Pro_Train_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/3/30.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 获取训练详情 */
@interface PK_Pro_Train_Get_Request : ETRequest

- (id)initWithTrainID:(NSInteger)trainID;

@end
