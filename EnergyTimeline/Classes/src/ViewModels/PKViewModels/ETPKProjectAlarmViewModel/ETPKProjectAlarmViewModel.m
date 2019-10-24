//
//  ETPKProjectAlarmViewModel.m
//  能量圈
//
//  Created by 王斌 on 2018/1/24.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectAlarmViewModel.h"
#import "PK_Project_Clock_Get_Request.h"
#import "PK_Project_Clock_Add_Request.h"

@implementation ETPKProjectAlarmViewModel

- (void)et_initialize {
    
    @weakify(self)
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.model = [[ETAlarmModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.isOpen = [self.model.Is_Enabled boolValue];
            self.selectWeekArray = [NSMutableArray arrayWithArray:[self.model.RemindDate componentsSeparatedByString:@","]];
            [self.refreshEndSubject sendNext:nil];
        }
    }];
    
    [self.alarmUpdateCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [self.completedSubject sendNext:nil];
            NSLog(@"完成");
        }
    }];
    
}

#pragma mark -- lazyLoad --

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Project_Clock_Get_Request *clockRequest = [[PK_Project_Clock_Get_Request alloc] initWithProjectID:[self.projectModel.ProjectID integerValue]];
                [clockRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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

- (RACCommand *)alarmUpdateCommand {
    if (!_alarmUpdateCommand) {
        _alarmUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableString *remindDate = [[NSMutableString alloc] initWithFormat:@""];
                for (int i = 0; i < self.selectWeekArray.count; i++) {
                    if (![self.selectWeekArray[i] isEqualToString:@","]) {
                        [remindDate appendString:[NSString stringWithFormat:@"%@,", self.selectWeekArray[i]]];
                    }
                }
                PK_Project_Clock_Add_Request *clockAddRequest = [[PK_Project_Clock_Add_Request alloc] initWithClockID:[self.model.ClockID integerValue] ProjectID:[self.projectModel.ProjectID integerValue] Is_Enabled:ETBOOL(self.isOpen) RemindTime:[NSString stringWithFormat:@"%@:%@", self.hour, self.minute] RemindDate:remindDate];
                [clockAddRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _alarmUpdateCommand;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)completedSubject {
    if (!_completedSubject) {
        _completedSubject = [RACSubject subject];
    }
    return _completedSubject;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSArray *)weeks {
    if (!_weeks) {
        _weeks = @[@"周日",
                   @"周一",
                   @"周二",
                   @"周三",
                   @"周四",
                   @"周五",
                   @"周六"];
    }
    return _weeks;
}

- (NSArray *)hours {
    if (!_hours) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i <= 23; i++) {
            if (i < 10) {
                [array addObject:[NSString stringWithFormat:@"0%i", i]];
            } else {
                [array addObject:[NSString stringWithFormat:@"%i", i]];
            }
        }
        _hours = array;
    }
    return _hours;
}

- (NSArray *)minutes {
    if (!_minutes) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i <= 59; i++) {
            if (i < 10) {
                [array addObject:[NSString stringWithFormat:@"0%i", i]];
            } else {
                [array addObject:[NSString stringWithFormat:@"%i", i]];
            }
        }
        _minutes = array;
    }
    return _minutes;
}

@end
