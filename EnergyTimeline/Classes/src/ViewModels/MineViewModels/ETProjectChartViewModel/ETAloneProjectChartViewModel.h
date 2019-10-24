//
//  ETAloneProjectChartViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/8/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETAloneProjectChartViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshFirstEndSubject;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, assign) BOOL isRequestData;

@property (nonatomic, assign) NSInteger projectID;

@property (nonatomic, assign) NSInteger userID;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) double maximum;

@property (nonatomic, assign) NSInteger maximumIndex;

@property (nonatomic, assign) NSInteger selectedIndexX;

@property (nonatomic, assign) NSInteger selectedIndexY;

@property (nonatomic, assign) BOOL isAllData;

#pragma mark -- 项目数据 --

@property (nonatomic, strong) RACSubject *refreshProjectEndSubject;

@property (nonatomic, strong) RACCommand *refreshProjectDataCommand;

@property (nonatomic, strong) RACCommand *nextProjectPageCommand;

@property (nonatomic, strong) NSArray *projectDataArray;

@end
