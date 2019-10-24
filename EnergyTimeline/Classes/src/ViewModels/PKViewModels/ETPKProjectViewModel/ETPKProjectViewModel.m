//
//  ETPKProjectViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectViewModel.h"
#import "PK_My_Report_Ranking_Request.h"
#import "PK_Report_Rank_List_Request.h"
#import "PK_Report_Record_Project_List_Request.h"
#import "PK_Likes_Add_Request.h" // 喜欢
#import "PK_Likes_Add_Limit_One_Request.h" // 喜欢(上限为1)

#import "ETPKProjectRecordModel.h"

@interface ETPKProjectViewModel ()

@property (nonatomic, assign) NSInteger currentRankPage;

@property (nonatomic, assign) NSInteger currentRecordPage;

@end

@implementation ETPKProjectViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.myReportDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSLog(@"%@", responseObject);
            ETPKProjectMyReportModel *model = [[ETPKProjectMyReportModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.myReportModel = model;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshRankDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                if ([model.Ranking isEqualToString:@"1"]) {
                    self.rankFirstModel = model;
                }
                [array addObject:model];
            }
            self.rankDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshRecordDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETPKProjectRecordModel *model = [[ETPKProjectRecordModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.recordDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.nextPageRankCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.rankDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.rankDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.nextPageRecordDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.recordDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETPKProjectRecordModel *model = [[ETPKProjectRecordModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.recordDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
}

#pragma mark -- lazyLoad --

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACCommand *)myReportDataCommand {
    if (!_myReportDataCommand) {
        @weakify(self)
        _myReportDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                PK_My_Report_Ranking_Request *myReportRequest = [[PK_My_Report_Ranking_Request alloc] initWithProjectID:[self.model.ProjectID integerValue]];
                [myReportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _myReportDataCommand;
}

- (RACCommand *)refreshRankDataCommand {
    if (!_refreshRankDataCommand) {
        @weakify(self)
        _refreshRankDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentRankPage = 1;
                PK_Report_Rank_List_Request *reportRankRequest = [[PK_Report_Rank_List_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] PageIndex:self.currentRankPage PageSize:15];
                [reportRankRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请登录"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshRankDataCommand;
}


- (RACCommand *)refreshRecordDataCommand {
    if (!_refreshRecordDataCommand) {
        @weakify(self)
        _refreshRecordDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentRecordPage = 1;
//                PK_My_Report_Ranking_Request *reportRankRequest = [[PK_My_Report_Ranking_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] PageIndex:self.currentRecordPage PageSize:15];
                PK_Report_Record_Project_List_Request *reportRecordRequest = [[PK_Report_Record_Project_List_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] PageIndex:self.currentRecordPage PageSize:15];
                [reportRecordRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请登录"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshRecordDataCommand;
}

- (RACCommand *)nextPageRankCommand {
    if (!_nextPageRankCommand) {
        @weakify(self)
        _nextPageRankCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentRankPage ++;
                PK_Report_Rank_List_Request *reportRankRequest = [[PK_Report_Rank_List_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] PageIndex:self.currentRankPage PageSize:15];
                [reportRankRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请登录"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageRankCommand;
}


- (RACCommand *)nextPageRecordDataCommand {
    if (!_nextPageRecordDataCommand) {
        @weakify(self)
        _nextPageRecordDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentRecordPage ++;
                PK_Report_Record_Project_List_Request *reportRecordRequest = [[PK_Report_Record_Project_List_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] PageIndex:self.currentRecordPage PageSize:15];
                [reportRecordRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请登录"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageRecordDataCommand;
}

- (RACCommand *)likeReportCommand {
    if (!_likeReportCommand) {
        _likeReportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *reportID) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Likes_Add_Request *likeRequest = [[PK_Likes_Add_Request alloc] initWithReportID:[reportID integerValue]];
                [likeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        NSLog(@"Status 200");
                    }
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"点赞失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _likeReportCommand;
}

- (RACCommand *)likeLimitOneCommand {
    if (!_likeLimitOneCommand) {
        _likeLimitOneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(ETDailyPKProjectRankListModel *model) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Likes_Add_Limit_One_Request *likeLimitOneRequest = [[PK_Likes_Add_Limit_One_Request alloc] initWithToUserID:[model.UserID integerValue] ProjectID:[model.ProjectID integerValue]];
                [likeLimitOneRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        NSLog(@"Status 200");
                    }
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"点赞失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _likeLimitOneCommand;
}

- (NSArray *)rankDataArray {
    if (!_rankDataArray) {
        _rankDataArray = [[NSArray alloc] init];
    }
    return _rankDataArray;
}

- (NSArray *)recordDataArray {
    if (!_recordDataArray) {
        _recordDataArray = [[NSArray alloc] init];
    }
    return _recordDataArray;
}

- (RACSubject *)projectAlarmSubject {
    if (!_projectAlarmSubject) {
        _projectAlarmSubject = [RACSubject subject];
    }
    return _projectAlarmSubject;
}

- (RACSubject *)integralRuleSubject {
    if (!_integralRuleSubject) {
        _integralRuleSubject = [RACSubject subject];
    }
    return _integralRuleSubject;
}

- (RACSubject *)setupPKCoverSubject {
    if (!_setupPKCoverSubject) {
        _setupPKCoverSubject = [RACSubject subject];
    }
    return _setupPKCoverSubject;
}

- (RACSubject *)likeClickSubject {
    if (!_likeClickSubject) {
        _likeClickSubject = [RACSubject subject];
    }
    return _likeClickSubject;
}

- (RACSubject *)refreshSubject {
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}


@end
