//
//  ETIntegralRankViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralRankViewModel.h"
#import "PK_MyIntegral_Ranking_Request.h"
#import "PK_Integral_Rank_List_Request.h"
#import "PK_Friend_Integral_Ranking_List_Request.h"
#import "ETIntegralRankTableViewCellViewModel.h"

@interface ETIntegralRankViewModel ()

@property (nonatomic, assign) NSInteger worldCurrentPage;
@property (nonatomic, assign) NSInteger friendCurrentPage;

@end

@implementation ETIntegralRankViewModel

- (void)et_initialize {
    @weakify(self)
    
    self.currentSegment = 0;
    
    [[self.syncSegmentSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *index) {
        @strongify(self)
        self.currentSegment = [index integerValue];
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.myIntegralDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.model = [[ETRankModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRankModel *model = [[ETRankModel alloc] initWithDictionary:dic error:nil];
                ETIntegralRankTableViewCellViewModel *viewModel = [[ETIntegralRankTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.worldDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.worldDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRankModel *model = [[ETRankModel alloc] initWithDictionary:dic error:nil];
                ETIntegralRankTableViewCellViewModel *viewModel = [[ETIntegralRankTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.worldDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshFriendDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRankModel *model = [[ETRankModel alloc] initWithDictionary:dic error:nil];
                ETIntegralRankTableViewCellViewModel *viewModel = [[ETIntegralRankTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.friendDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.nextFriendPageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.friendDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRankModel *model = [[ETRankModel alloc] initWithDictionary:dic error:nil];
                ETIntegralRankTableViewCellViewModel *viewModel = [[ETIntegralRankTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.friendDataArray = array;
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

- (RACSubject *)refreshScrollSubject {
    if (!_refreshScrollSubject) {
        _refreshScrollSubject = [RACSubject subject];
    }
    return _refreshScrollSubject;
}

- (RACCommand *)myIntegralDataCommand {
    if (!_myIntegralDataCommand) {
        _myIntegralDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSubject createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_MyIntegral_Ranking_Request *myIntegralRequest = [[PK_MyIntegral_Ranking_Request alloc] init];
                [myIntegralRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _myIntegralDataCommand;
}

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.worldCurrentPage = 1;
                PK_Integral_Rank_List_Request *integralRequest = [[PK_Integral_Rank_List_Request alloc] initWithPageIndex:self.worldCurrentPage PageSize:15];
                [integralRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    if (!_nextPageCommand) {
        @weakify(self)
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.worldCurrentPage ++;
                PK_Integral_Rank_List_Request *integralRequest = [[PK_Integral_Rank_List_Request alloc] initWithPageIndex:self.worldCurrentPage PageSize:15];
                [integralRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _nextPageCommand;
}

- (RACCommand *)refreshFriendDataCommand {
    if (!_refreshFriendDataCommand) {
        @weakify(self)
        _refreshFriendDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.friendCurrentPage = 1;
                PK_Friend_Integral_Ranking_List_Request *integralRequest = [[PK_Friend_Integral_Ranking_List_Request alloc] initWithPageIndex:self.friendCurrentPage PageSize:15];
                [integralRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _refreshFriendDataCommand;
}

- (RACCommand *)nextFriendPageCommand {
    if (!_nextFriendPageCommand) {
        @weakify(self)
        _nextFriendPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.friendCurrentPage ++;
                PK_Friend_Integral_Ranking_List_Request *integralRequest = [[PK_Friend_Integral_Ranking_List_Request alloc] initWithPageIndex:self.friendCurrentPage PageSize:15];
                [integralRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _nextFriendPageCommand;
}

- (NSArray *)worldDataArray {
    if (!_worldDataArray) {
        _worldDataArray = [[NSArray alloc] init];
    }
    return _worldDataArray;
}

- (NSArray *)friendDataArray {
    if (!_friendDataArray) {
        _friendDataArray = [[NSArray alloc] init];
    }
    return _friendDataArray;
}

- (RACSubject *)syncSegmentSubject {
    if (!_syncSegmentSubject) {
        _syncSegmentSubject = [RACSubject subject];
    }
    return _syncSegmentSubject;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

- (RACSubject *)integralRuleSubject {
    if (!_integralRuleSubject) {
        _integralRuleSubject = [RACSubject subject];
    }
    return _integralRuleSubject;
}

@end
