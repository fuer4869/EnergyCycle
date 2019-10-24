//
//  PK_Pro_Train_Group_Upd_Request.h
//  能量圈
//
//  Created by 王斌 on 2018/4/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 更新每组训练数据 */
@interface PK_Pro_Train_Group_Upd_Request : ETRequest

- (id)initWithTrainID:(NSInteger)trainID GroupNo:(NSInteger)groupNo Duration:(NSInteger)duration;

@end
