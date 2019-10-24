//
//  ETDailyPKViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKViewModel.h"
#import "ETDailyPKProjectRankListModel.h"
#import "ETDailyPKTableViewCellViewModel.h"

#import "PK_Report_Rank_List_Request.h"
#import "PK_MyReport_Get_Request.h"
#import "PK_Likes_Add_Request.h"

@interface ETDailyPKViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL empty;

@end

@implementation ETDailyPKViewModel

- (void)et_initialize {
    @weakify(self)
    [self.mineCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.mineViewModel.model = model;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                if ([model.Ranking isEqualToString:@"1"]) {
                    self.headerViewModel.model = model;
                }
                ETDailyPKTableViewCellViewModel *viewModel = [[ETDailyPKTableViewCellViewModel alloc] init];
                viewModel.homePageSubejct = self.homePageSubject;
                viewModel.likeClickSubject = self.likeClickSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
        }
        [self.refreshFirstEndSubject sendNext:nil];
    }];
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                ETDailyPKTableViewCellViewModel *viewModel = [[ETDailyPKTableViewCellViewModel alloc] init];
                viewModel.homePageSubejct = self.homePageSubject;
                viewModel.likeClickSubject = self.likeClickSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
}

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

- (RACCommand *)mineCommand {
    if (!_mineCommand) {
        @weakify(self)
        _mineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                PK_MyReport_Get_Request *mineRequest = [[PK_MyReport_Get_Request alloc] initWithProjectID:[self.model.ProjectID integerValue]];
                [mineRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _mineCommand;
}

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPage = 1;
                PK_Report_Rank_List_Request *reportRankRequest = [[PK_Report_Rank_List_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] PageIndex:self.currentPage PageSize:10];
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
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    if (!_nextPageCommand) {
        @weakify(self)
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPage ++;
                PK_Report_Rank_List_Request *reportRankRequest = [[PK_Report_Rank_List_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] PageIndex:self.currentPage PageSize:10];
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
    return _nextPageCommand;
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

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (ETDailyPKHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[ETDailyPKHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}

- (ETDailyPKMineViewModel *)mineViewModel {
    if (!_mineViewModel) {
        _mineViewModel = [[ETDailyPKMineViewModel alloc] init];
        _mineViewModel.homePageSubject = self.homePageSubject;
        _mineViewModel.likeClickSubject = self.likeClickSubject;
        _mineViewModel.submitSubject = self.submitSubject;
        _mineViewModel.setupSubject = self.setupSubject;
    }
    return _mineViewModel;
}

- (ETDailyPKTableViewCellViewModel *)cellModel {
    if (!_cellModel) {
        _cellModel = [[ETDailyPKTableViewCellViewModel alloc] init];
        _cellModel.likeClickSubject = self.likeClickSubject;
    }
    return _cellModel;
}

- (RACSubject *)refreshSubject {
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

- (RACSubject *)homePageSubject {
    if (!_homePageSubject) {
        _homePageSubject = [RACSubject subject];
    }
    return _homePageSubject;
}

- (RACSubject *)likeClickSubject {
    if (!_likeClickSubject) {
        _likeClickSubject = [RACSubject subject];
    }
    return _likeClickSubject;
}

- (RACSubject *)submitSubject {
    if (!_submitSubject) {
        _submitSubject = [RACSubject subject];
    }
    return _submitSubject;
}

- (RACSubject *)setupSubject {
    if (!_setupSubject) {
        _setupSubject = [RACSubject subject];
    }
    return _setupSubject;
}

@end
