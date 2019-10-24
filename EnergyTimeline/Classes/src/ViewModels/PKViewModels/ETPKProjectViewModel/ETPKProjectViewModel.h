//
//  ETPKProjectViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETDailyPKProjectRankListModel.h"
#import "ETPKProjectMyReportModel.h"

@interface ETPKProjectViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *myReportDataCommand; // 查看是否发布动态

@property (nonatomic, strong) RACCommand *refreshRankDataCommand;

@property (nonatomic, strong) RACCommand *refreshRecordDataCommand;

@property (nonatomic, strong) RACCommand *nextPageRankCommand;

@property (nonatomic, strong) RACCommand *nextPageRecordDataCommand;

@property (nonatomic, strong) RACCommand *likeReportCommand; // 喜欢(普通项目)

@property (nonatomic, strong) RACCommand *likeLimitOneCommand; // 喜欢(提交上限为1的项目,例如:戒游戏,戒网络小说)

@property (nonatomic, strong) NSArray *rankDataArray;

@property (nonatomic, strong) NSArray *recordDataArray;

@property (nonatomic, strong) RACSubject *projectAlarmSubject;

@property (nonatomic, strong) RACSubject *integralRuleSubject; // 积分规则

@property (nonatomic, strong) RACSubject *setupPKCoverSubject; // 设置封面背景

@property (nonatomic, strong) RACSubject *likeClickSubject; // 喜欢

@property (nonatomic, strong) RACSubject *refreshSubject; // 刷新

@property (nonatomic, strong) ETPKProjectMyReportModel *myReportModel;

@property (nonatomic, strong) ETDailyPKProjectRankListModel *rankFirstModel;

@property (nonatomic, strong) ETDailyPKProjectRankListModel *model;

@end
