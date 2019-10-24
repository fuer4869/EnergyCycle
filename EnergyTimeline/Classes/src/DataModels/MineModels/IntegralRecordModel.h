//
//  IntegralRecordModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface IntegralRecordModel : JSONModel

/** 获得积分时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 积分数 */
@property (nonatomic, strong) NSString<Optional> *Integral;
/** 积分来源 */
@property (nonatomic, strong) NSString<Optional> *IntegralEvent;
/** 积分ID */
@property (nonatomic, strong) NSString<Optional> *IntegralID;
/** 来源ID */
@property (nonatomic, strong) NSString<Optional> *SourceID;
/** 来源名称 */
@property (nonatomic, strong) NSString<Optional> *SourceName;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

@end
