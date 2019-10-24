//
//  ETLikeRankListViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLikeRankListViewModel.h"
#import "ETRankModel.h"
#import "ETPKStatisticsModel.h"
#import "PK_LikesRank_List_Request.h"
#import "PK_Statistics_List_Request.h"
#import "ETLikeRankListTableViewCellViewModel.h"

@interface ETLikeRankListViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETLikeRankListViewModel

- (void)et_initialize {
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRankModel *model = [[ETRankModel alloc] initWithDictionary:dic error:nil];
                ETLikeRankListTableViewCellViewModel *viewModel = [[ETLikeRankListTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRankModel *model = [[ETRankModel alloc] initWithDictionary:dic error:nil];
                ETLikeRankListTableViewCellViewModel *viewModel = [[ETLikeRankListTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.myLikeCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            for (NSDictionary *dic  in responseObject[@"Data"]) {
                ETPKStatisticsModel *model = [[ETPKStatisticsModel alloc] initWithDictionary:dic error:nil];
                if ([model.ProjectName isEqualToString:@"获赞排名"]) {
                    self.headerViewModel.likeRank = model.Num;
                } else if ([model.ProjectName isEqualToString:@"获赞个数"]) {
                    self.headerViewModel.likeCount = model.Num;
                }
            }
        }
        [self.refreshEndSubject sendNext:nil];
    }];
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
                self.currentPage = 1;
                PK_LikesRank_List_Request *likesRankRequest = [[PK_LikesRank_List_Request alloc] initWithPageIndex:self.currentPage PageSize:10];
                [likesRankRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
                PK_LikesRank_List_Request *likesRankRequest = [[PK_LikesRank_List_Request alloc] initWithPageIndex:self.currentPage PageSize:10];
                [likesRankRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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

- (RACCommand *)myLikeCommand {
    if (!_myLikeCommand) {
        _myLikeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Statistics_List_Request *statisticsRequest = [[PK_Statistics_List_Request alloc] init];
                [statisticsRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _myLikeCommand;
}

- (ETLikeRankHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[ETLikeRankHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (RACSubject *)cellClikeSubject {
    if (!_cellClikeSubject) {
        _cellClikeSubject = [RACSubject subject];
    }
    return _cellClikeSubject;
}

- (RACSubject *)headerCellClickSubject {
    if (!_headerCellClickSubject) {
        _headerCellClickSubject = [RACSubject subject];
    }
    return _headerCellClickSubject;
}

@end
