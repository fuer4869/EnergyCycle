//
//  ETPKProjectAlarmViewModel.h
//  能量圈
//
//  Created by 王斌 on 2018/1/24.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETDailyPKProjectRankListModel.h"
#import "ETAlarmModel.h"

@interface ETPKProjectAlarmViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *refreshDataCommand; // 获取项目提醒信息

@property (nonatomic, strong) RACCommand *alarmUpdateCommand; // 增加/修改项目提醒

@property (nonatomic, strong) RACSubject *refreshEndSubject; // 获取数据结束后

@property (nonatomic, strong) RACSubject *completedSubject; // 保存后退出

@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) ETDailyPKProjectRankListModel *projectModel;

@property (nonatomic, strong) ETAlarmModel *model;

@property (nonatomic, copy) NSString *hour;

@property (nonatomic, copy) NSString *minute;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, strong) NSMutableArray *selectWeekArray;

@property (nonatomic, strong) NSArray *weeks;

@property (nonatomic, strong) NSArray *hours;

@property (nonatomic, strong) NSArray *minutes;

@end
