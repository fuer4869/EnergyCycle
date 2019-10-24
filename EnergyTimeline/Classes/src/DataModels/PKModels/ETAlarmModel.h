//
//  ETAlarmModel.h
//  能量圈
//
//  Created by 王斌 on 2018/1/25.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETAlarmModel : JSONModel

/** 闹钟ID */
@property (nonatomic, strong) NSString<Optional> *ClockID;
/** pk项目 */
@property (nonatomic, strong) NSString<Optional> *ProjectID;
/** 是否激活 */
@property (nonatomic, strong) NSString<Optional> *Is_Enabled;
/** 提醒时间 */
@property (nonatomic, strong) NSString<Optional> *RemindTime;
/** 提醒的星期数 */
@property (nonatomic, strong) NSString<Optional> *RemindDate;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

@end
