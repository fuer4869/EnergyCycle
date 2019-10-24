//
//  ETPKReportPopViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETDailyPKProjectRankListModel.h"

@interface ETPKReportPopViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *reportCommand;

@property (nonatomic, strong) RACSubject *textFieldSubject;

@property (nonatomic, strong) RACSubject *reportCompletedSubject;

@property (nonatomic, strong) RACSubject *projectAlarmSubject;

@property (nonatomic, strong) NSMutableArray *projectNumArray;

@property (nonatomic, strong) ETDailyPKProjectRankListModel *model;

@end
