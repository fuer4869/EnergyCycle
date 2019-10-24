//
//  PK_Pro_Train_End_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/4/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 训练结束(中断) */
@interface PK_Pro_Train_End_Request : ETRequest

- (id)initWithTrainID:(NSInteger)trainID;

@end