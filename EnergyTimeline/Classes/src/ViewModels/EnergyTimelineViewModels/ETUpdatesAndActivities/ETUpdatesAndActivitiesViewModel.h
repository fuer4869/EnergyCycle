//
//  ETUpdatesAndActivitiesViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/8/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETSysModel.h"

@interface ETUpdatesAndActivitiesViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *versionCommand;

@property (nonatomic, strong) RACCommand *sysDataCommand;

@property (nonatomic, strong) RACSubject *versionSubject;

@property (nonatomic, strong) RACSubject *endSubject;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) ETSysModel *versionModel;

@property (nonatomic, assign) BOOL updateRemind; // 更新提醒

@property (nonatomic, assign) BOOL functionRemind; // 新功能提醒

#pragma mark -- 外部 --

@property (nonatomic, strong) RACSubject *activePageSubject;

@property (nonatomic, strong) RACSubject *functionSubject;

/** 没有(结束)更新和活动时调用 */
@property (nonatomic, strong) RACSubject *nothingSubject;

//@property (nonatomic)

@end
