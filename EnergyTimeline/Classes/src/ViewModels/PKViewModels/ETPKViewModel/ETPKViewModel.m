//
//  ETPKViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKViewModel.h"
#import "ETDailyPKProjectRankListModel.h"
//#import "PK_Report_Post_Add.h"
#import "PK_CheckIn_Add_Request.h"
#import "PK_MyCheckIn_Get_Request.h"
#import "PK_CheckIn_IsExists_Request.h"
#import "PK_MyIntegral_Ranking_Request.h" // 我的积分详情
#import "PK_ReportProject_Del_Request.h" // 删除项目
#import "User_FirstEnter_Get_Request.h"
#import "User_FirstEnter_Upd_Request.h"
#import "PK_v3_Report_Post_IsHaveNewRepost.h" // 判断是否有新的汇报项目
#import "Mine_Notice_NotReadCount_Num_Request.h"

#import "PK_Pro_Train_Is_Exists_Request.h" // 查看是否还有未完成的训练
#import "PK_Pro_Train_End_Request.h" // 结束训练

//#import "PK_Report_List_Today_UserID_Request.h"

#import "PK_Report_List_Sta_Request.h"

@implementation ETPKViewModel

- (void)et_initialize {
    @weakify(self)
    
    self.userID = 0;
    
    [self.signStatusCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.signStatus = [responseObject[@"Data"] integerValue];
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.myCheckInCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            ETPKMyCheckInModel *model = [[ETPKMyCheckInModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.myCheckInModel = model;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.myIntegralCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            ETRankModel *model = [[ETRankModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.myIntegralModel = model;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshPKCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.pkDataArray = array;
        }
        [self.refreshPKEndSubject sendNext:nil];
    }];
    
    [self.projectDelCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [self.refreshPKCommand execute:nil];
        }
    }];
    
    [self.firstEnterDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.firstEnterModel = [[ETFirstEnterModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.firstEnterEndSubject sendNext:nil];
        }
    }];
    
    [self.noticeDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.noticeNotReadCount = [responseObject[@"Data"] integerValue];
            [self.noticeRemindSubject sendNext:nil];
        }
    }];
    
    [self.unfinishedTrainCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && ![responseObject[@"Data"] isKindOfClass:[NSNull class]]) {
            ETPKProjectTrainModel *model = [[ETPKProjectTrainModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.unfinishedTrainModel = model;
            if ([self.unfinishedTrainModel.TrainID integerValue]) {
                [self.unfinishedTrainSubject sendNext:nil];
            }
        }
    }];
    
    [self.trainEndCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
//        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"结束训练成功");
        }
    }];
    
}

#pragma mark -- lazyLoad --

- (RACCommand *)pkReportCommand {
    if (!_pkReportCommand) {
        _pkReportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_v3_Report_Post_IsHaveNewRepost *reportRequest = [[PK_v3_Report_Post_IsHaveNewRepost alloc] init];
                [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _pkReportCommand;
}

- (RACCommand *)signStatusCommand {
    if (!_signStatusCommand) {
        _signStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_CheckIn_IsExists_Request *isExistsRequest = [[PK_CheckIn_IsExists_Request alloc] init];
                [isExistsRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _signStatusCommand;
}

- (RACCommand *)signCommand {
    if (!_signCommand) {
        _signCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_CheckIn_Add_Request *signRequest = [[PK_CheckIn_Add_Request alloc] init];
                [signRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _signCommand;
}

- (RACCommand *)myCheckInCommand {
    if (!_myCheckInCommand) {
        _myCheckInCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_MyCheckIn_Get_Request *myCheckInRequest = [[PK_MyCheckIn_Get_Request alloc] init];
                [myCheckInRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _myCheckInCommand;
}

- (RACCommand *)myIntegralCommand {
    if (!_myIntegralCommand) {
        _myIntegralCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSubject createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_MyIntegral_Ranking_Request *myIntegralRequest = [[PK_MyIntegral_Ranking_Request alloc] init];
                [myIntegralRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _myIntegralCommand;
}

- (RACCommand *)refreshPKCommand {
    if (!_refreshPKCommand) {
        _refreshPKCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Report_List_Sta_Request *reportListRequest = [[PK_Report_List_Sta_Request alloc] init];
                [reportListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshPKCommand;
}

- (RACCommand *)projectDelCommand {
    if (!_projectDelCommand) {
        @weakify(self)
        _projectDelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                ETDailyPKProjectRankListModel *model = self.pkDataArray[self.delCellIndexPath.row];
                PK_ReportProject_Del_Request *projectDelRequest = [[PK_ReportProject_Del_Request alloc] initWithProjectID:[model.ProjectID integerValue]];
                [projectDelRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _projectDelCommand;
}

- (RACCommand *)firstEnterDataCommand {
    if (!_firstEnterDataCommand) {
        _firstEnterDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_FirstEnter_Get_Request *firstEnterGetRequest = [[User_FirstEnter_Get_Request alloc] init];
                [firstEnterGetRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _firstEnterDataCommand;
}

- (RACCommand *)firstEnterUpdCommand {
    if (!_firstEnterUpdCommand) {
        _firstEnterUpdCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *str) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_FirstEnter_Upd_Request *firstEnterUpdRequest = [[User_FirstEnter_Upd_Request alloc] initWithStr:str];
                [firstEnterUpdRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _firstEnterUpdCommand;
}

/** 通知未读信息 */
- (RACCommand *)noticeDataCommand {
    if (!_noticeDataCommand) {
        _noticeDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Mine_Notice_NotReadCount_Num_Request *notReadRequest = [[Mine_Notice_NotReadCount_Num_Request alloc] init];
                [notReadRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _noticeDataCommand;
}

/** 查看当前是否有未完成的训练 */
- (RACCommand *)unfinishedTrainCommand {
    if (!_unfinishedTrainCommand) {
        _unfinishedTrainCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_Is_Exists_Request *trainRequest = [[PK_Pro_Train_Is_Exists_Request alloc] init];
                [trainRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _unfinishedTrainCommand;
}

// 结束(中断)训练项目
- (RACCommand *)trainEndCommand {
    if (!_trainEndCommand) {
        _trainEndCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_End_Request *trainEndRequest = [[PK_Pro_Train_End_Request alloc] initWithTrainID:[self.unfinishedTrainModel.TrainID integerValue]];
                [trainEndRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _trainEndCommand;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)refreshPKEndSubject {
    if (!_refreshPKEndSubject) {
        _refreshPKEndSubject = [RACSubject subject];
    }
    return _refreshPKEndSubject;
}

- (RACSubject *)integralRankSubject {
    if (!_integralRankSubject) {
        _integralRankSubject = [RACSubject subject];
    }
    return _integralRankSubject;
}

- (RACSubject *)projectRankSubject {
    if (!_projectRankSubject) {
        _projectRankSubject = [RACSubject subject];
    }
    return _projectRankSubject;
}

- (RACSubject *)pkReportSubject {
    if (!_pkReportSubject) {
        _pkReportSubject = [RACSubject subject];
    }
    return _pkReportSubject;
}

- (RACSubject *)myCheckInClickSubject {
    if (!_myCheckInClickSubject) {
        _myCheckInClickSubject = [RACSubject subject];
    }
    return _myCheckInClickSubject;
}

- (RACSubject *)rightSideClickSubject {
    if (!_rightSideClickSubject) {
        _rightSideClickSubject = [RACSubject subject];
    }
    return _rightSideClickSubject;
}

- (RACSubject *)unfinishedTrainSubject {
    if (!_unfinishedTrainSubject) {
        _unfinishedTrainSubject = [RACSubject subject];
    }
    return _unfinishedTrainSubject;
}

- (RACSubject *)projectCellClickSubject {
    if (!_projectCellClickSubject) {
        _projectCellClickSubject = [RACSubject subject];
    }
    return _projectCellClickSubject;
}

- (RACSubject *)noticeRemindSubject {
    if (!_noticeRemindSubject) {
        _noticeRemindSubject = [RACSubject subject];
    }
    return _noticeRemindSubject;
}

- (RACSubject *)remindEndSubject {
    if (!_remindEndSubject) {
        _remindEndSubject = [RACSubject subject];
    }
    return _remindEndSubject;
}

- (RACSubject *)firstEnterEndSubject {
    if (!_firstEnterEndSubject) {
        _firstEnterEndSubject = [RACSubject subject];
    }
    return _firstEnterEndSubject;
}

- (NSArray *)pkDataArray {
    if (!_pkDataArray) {
        _pkDataArray = [[NSArray alloc] init];
    }
    return _pkDataArray;
}



@end
