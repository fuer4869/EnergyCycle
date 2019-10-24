//
//  ETTrainViewModel.h
//  能量圈
//
//  Created by 王斌 on 2018/3/19.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETPKProjectTrainModel.h"

@interface ETTrainViewModel : ETViewModel

/** 获取训练详情 */
@property (nonatomic, strong) RACCommand *trainGetCommand;
/** 更新训练进度 */
@property (nonatomic, strong) RACCommand *trainUpdateCommand;
/** 训练结束(中断) */
@property (nonatomic, strong) RACCommand *trainEndCommand;
/** 训练完成 */
@property (nonatomic, strong) RACCommand *trainFinishCommand;
/** 返回 */
@property (nonatomic, strong) RACSubject *backSubject;
/** 刷新视图 */
@property (nonatomic, strong) RACSubject *refreshSubject;
/** 开始训练 */
@property (nonatomic, strong) RACSubject *startTrainSubject;
/** 继续训练 */
@property (nonatomic, strong) RACSubject *continueTrainSubject;
/** 休息开始 */
@property (nonatomic, strong) RACSubject *restStartSubject;
/** 休息结束 */
@property (nonatomic, strong) RACSubject *restEndSubject;
/** 设置 */
@property (nonatomic, strong) RACSubject *setupSubject;

@property (nonatomic, strong) RACSubject *trainEndSubject;

@property (nonatomic, strong) RACSubject *trainFinishSubject;

@property (nonatomic, strong) RACSubject *trainFinishEndSubject;

@property (nonatomic, strong) RACSubject *closeSubject;

/** 音频播放列表 */
@property (nonatomic, strong) NSArray *audioPlayList;
/** 忽视下载页面 */
@property (nonatomic, assign) BOOL ignoreDownload;
/** 是否为继续(恢复)训练 */
@property (nonatomic, assign) BOOL isContinue;
/** 是否正在休息 */
@property (nonatomic, assign) BOOL isResting;
/** 是否完成 */
@property (nonatomic, assign) BOOL isComplete;
/** 训练ID */
@property (nonatomic, assign) NSInteger trainID;
/** 训练模型 */
@property (nonatomic, strong) ETPKProjectTrainModel *model;
///** 总持续时间 */
//@property (nonatomic, assign) CGFloat *totalDuration;

@end
