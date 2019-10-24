//
//  ETDailyPKViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETDailyPKHeaderViewModel.h"
#import "ETDailyPKMineViewModel.h"
#import "ETDailyPKTableViewCellViewModel.h"
#import "ETPKProjectModel.h"

@interface ETDailyPKViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshFirstEndSubject;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *mineCommand;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *likeReportCommand;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) ETDailyPKHeaderViewModel *headerViewModel;

@property (nonatomic, strong) ETDailyPKMineViewModel *mineViewModel;

@property (nonatomic, strong) ETDailyPKTableViewCellViewModel *cellModel;

@property (nonatomic, strong) RACSubject *refreshSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *homePageSubject;

@property (nonatomic, strong) RACSubject *likeClickSubject;

@property (nonatomic, strong) RACSubject *submitSubject;

@property (nonatomic, strong) RACSubject *setupSubject;

@property (nonatomic, strong) ETPKProjectModel *model;

@end
