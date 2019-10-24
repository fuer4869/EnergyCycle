//
//  ETProjectChartViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/8/7.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectChartViewModel.h"
#import "PKProjectChartModel.h"
#import "PK_Report_Sta_ByPID_Request.h"
#import "PK_Project_List_Requset.h"
#import "Mine_Report_List_UserID_Request.h"
//#import "PK_Report_List_Record_Request.h"

#import <Charts/Charts-Swift.h>

@implementation ETProjectChartViewModel

- (void)et_initialize {
    
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"][@"Report_List"] count]) {
            self.maximum = [responseObject[@"Data"][@"MaxReportNum"] doubleValue];
            self.selectedIndexX = -1; // 重新设置点击索引位置
            self.maximumIndex = -1; // 重新设置高亮线索引位置
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"][@"Report_List"]) {
                PKProjectChartModel *model = [[PKProjectChartModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.isAllData = array.count < 20;
            self.dataArray = array;
            
            [self.dataArr removeAllObjects];
            for (int i = 0; i < self.dataArray.count; i ++) {
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[[(PKProjectChartModel *)self.dataArray[i] ReportNum] doubleValue]];
                /** 判断数据中是否有曲线最大值 */
                if ([[(PKProjectChartModel *)self.dataArray[i] ReportNum] doubleValue] == self.maximum) {
                    self.maximumIndex = i;
                }
                /** 获取初始默认选中位置 */
                if (i == self.dataArray.count - 1) {
                    self.selectedIndexX = entry.x;
                    self.selectedIndexY = entry.y;
                }
                [self.dataArr addObject:entry];
            }
            
            [self.refreshFirstEndSubject sendNext:nil];
        }
    }];
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.maximum = [responseObject[@"Data"][@"MaxReportNum"] doubleValue];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"][@"Report_List"]) {
                PKProjectChartModel *model = [[PKProjectChartModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
                if (self.selectedIndexX != -1) {
                    self.selectedIndexX ++;
                }
            }
            self.isAllData = array.count < 20;
            NSArray *arr = [array arrayByAddingObjectsFromArray:self.dataArray];
            self.dataArray = arr;
            
            NSLog(@"已获取数据%d条", self.dataArray.count);
            
            [self.dataArr removeAllObjects];
            for (int i = 0; i < self.dataArray.count; i ++) {
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[[(PKProjectChartModel *)self.dataArray[i] ReportNum] doubleValue]];
                if ([[(PKProjectChartModel *)self.dataArray[i] ReportNum] doubleValue] == self.maximum) {
                    self.maximumIndex = i;
                }
                [self.dataArr addObject:entry];
            }
            
            [self.refreshEndSubject sendNext:nil];
        }
    }];
    
    [self.refreshProjectDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETPKProjectModel *model = [[ETPKProjectModel alloc] initWithDictionary:dic error:nil];
                ETProjectChartTableViewCellViewModel *viewModel = [[ETProjectChartTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.projectDataArray = array.copy;
            self.selectedProjectViewModel = array.firstObject;
            [array removeObjectAtIndex:0];
            self.unSelectedProjectArray = array;
        }
        [self.refreshProjectEndSubject sendNext:nil];
    }];
    
}

#pragma mark -- lazyLoad --

- (RACSubject *)refreshFirstEndSubject {
    if (!_refreshFirstEndSubject) {
        _refreshFirstEndSubject = [RACSubject subject];
    }
    return _refreshFirstEndSubject;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.startDate = [NSDate jk_dateAfterDate:[NSDate date] day:-19];
                self.endDate = [NSDate date];
//                PK_Report_Sta_ByPID_Request *projectRequest = [[PK_Report_Sta_ByPID_Request alloc] initWithProjectID:[self.selectedProjectViewModel.model.ProjectID integerValue] StartDate:[NSDate jk_stringWithDate:self.startDate format:[NSDate jk_ymdFormat]] EndDate:[NSDate jk_stringWithDate:self.endDate format:[NSDate jk_ymdFormat]]];
                PK_Report_Sta_ByPID_Request *projectRequest = [[PK_Report_Sta_ByPID_Request alloc] initWithProjectID:[self.selectedProjectViewModel.model.ProjectID integerValue] UserID:0 StartDate:[NSDate jk_stringWithDate:self.startDate format:[NSDate jk_ymdFormat]] EndDate:[NSDate jk_stringWithDate:self.endDate format:[NSDate jk_ymdFormat]]];
                [projectRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    if (!_nextPageCommand) {
        @weakify(self)
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.startDate = [NSDate jk_dateAfterDate:[NSDate date] day:-(self.dataArr.count + 19)];
                self.endDate = [NSDate jk_dateAfterDate:[NSDate date] day:-(self.dataArr.count)];
//                PK_Report_Sta_ByPID_Request *projectRequest = [[PK_Report_Sta_ByPID_Request alloc] initWithProjectID:[self.selectedProjectViewModel.model.ProjectID integerValue] StartDate:[NSDate jk_stringWithDate:self.startDate format:[NSDate jk_ymdFormat]] EndDate:[NSDate jk_stringWithDate:self.endDate format:[NSDate jk_ymdFormat]]];
                PK_Report_Sta_ByPID_Request *projectRequest = [[PK_Report_Sta_ByPID_Request alloc] initWithProjectID:[self.selectedProjectViewModel.model.ProjectID integerValue] UserID:0 StartDate:[NSDate jk_stringWithDate:self.startDate format:[NSDate jk_ymdFormat]] EndDate:[NSDate jk_stringWithDate:self.endDate format:[NSDate jk_ymdFormat]]];
                [projectRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageCommand;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

#pragma mark -- 项目数据列表 --

- (RACSubject *)refreshProjectEndSubject {
    if (!_refreshProjectEndSubject) {
        _refreshProjectEndSubject = [RACSubject subject];
    }
    return _refreshProjectEndSubject;
}

- (RACCommand *)refreshProjectDataCommand {
    if (!_refreshProjectDataCommand) {
        _refreshProjectDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Mine_Report_List_UserID_Request *projectListRequest = [[Mine_Report_List_UserID_Request alloc] initWithUserID:[User_ID integerValue]];
                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshProjectDataCommand;
}

- (NSMutableArray *)unSelectedProjectArray {
    if (!_unSelectedProjectArray) {
        _unSelectedProjectArray = [[NSMutableArray alloc] init];
    }
    return _unSelectedProjectArray;
}

- (NSArray *)projectDataArray {
    if (!_projectDataArray) {
        _projectDataArray = [[NSArray alloc] init];
    }
    return _projectDataArray;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

@end
