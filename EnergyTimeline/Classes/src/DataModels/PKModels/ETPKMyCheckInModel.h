//
//  ETPKMyCheckInModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPKMyCheckInModel : JSONModel

/** 累计签到 */
@property (nonatomic, strong) NSString<Optional> *CheckInDays;

/** 连续签到 */
@property (nonatomic, strong) NSString<Optional> *ContinueDays;

/** 早起签到天数 */
@property (nonatomic, strong) NSString<Optional> *EarlyDays;

/** 早起签到排名 */
@property (nonatomic, strong) NSString<Optional> *EarlyRanking;

@end
