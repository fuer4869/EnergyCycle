//
//  ETPKViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETPKMyCheckInModel.h"
#import "ETFirstEnterModel.h"
#import "ETRankModel.h"
#import "ETPKProjectTrainModel.h"

@interface ETPKViewModel : ETViewModel

@property (nonatomic, assign) NSInteger signStatus;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *pkReportCommand;

@property (nonatomic, strong) RACCommand *signStatusCommand; // 签到状态

@property (nonatomic, strong) RACCommand *signCommand; // 签到

@property (nonatomic, strong) RACCommand *myCheckInCommand;

@property (nonatomic, strong) RACCommand *myIntegralCommand;

@property (nonatomic, strong) RACCommand *refreshPKCommand; // 获取pk项目数据

@property (nonatomic, strong) RACCommand *projectDelCommand; // 删除项目

@property (nonatomic, strong) RACCommand *firstEnterDataCommand;

@property (nonatomic, strong) RACCommand *firstEnterUpdCommand;

@property (nonatomic, strong) RACCommand *noticeDataCommand;

@property (nonatomic, strong) RACCommand *unfinishedTrainCommand; // 查看未完成的训练

@property (nonatomic, strong) RACCommand *trainEndCommand; // 结束(中断)训练项目

@property (nonatomic, strong) RACSubject *refreshEndSubject; // 获取数据结束后

@property (nonatomic, strong) RACSubject *refreshPKEndSubject; // 获取pk数据后

@property (nonatomic, strong) RACSubject *integralRankSubject; // 积分排行榜

@property (nonatomic, strong) RACSubject *projectRankSubject; // pk项目总排行榜

@property (nonatomic, strong) RACSubject *pkReportSubject; // pk汇报

@property (nonatomic, strong) RACSubject *myCheckInClickSubject; // 签到

@property (nonatomic, strong) RACSubject *rightSideClickSubject; // 右侧pk项目汇报

@property (nonatomic, strong) RACSubject *projectCellClickSubject; // 项目点击触发方法

@property (nonatomic, strong) RACSubject *noticeRemindSubject;

@property (nonatomic, strong) RACSubject *remindEndSubject; // 提醒

@property (nonatomic, strong) RACSubject *firstEnterEndSubject;

@property (nonatomic, strong) RACSubject *unfinishedTrainSubject; // 提醒有未完成训练的回调方法

@property (nonatomic, strong) NSArray *pkDataArray; // 项目数据

@property (nonatomic, strong) ETPKMyCheckInModel *myCheckInModel;

@property (nonatomic, strong) ETRankModel *myIntegralModel;

@property (nonatomic, assign) NSInteger userID; // 用户ID

@property (nonatomic, assign) NSInteger noticeNotReadCount; // 通知数量

@property (nonatomic, strong) ETFirstEnterModel *firstEnterModel;

@property (nonatomic, strong) ETPKProjectTrainModel *unfinishedTrainModel; // 未完成训练model

@property (nonatomic, strong) NSIndexPath *delCellIndexPath; // 删除cell的下标路径

@end
