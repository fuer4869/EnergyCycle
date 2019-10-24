//
//  ETSignRankListViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSignRankListViewModel.h"
#import "PK_MyCheckIn_Get_Request.h" // 我的签到信息
#import "PK_CheckIn_Early_List_Request.h" // 签到列表
#import "PK_Likes_Add_Early_Request.h" // 签到列表点赞
#import "ETSignRankHeaderViewModel.h"
#import "ETRankTableViewCell.h"

@interface ETSignRankListViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETSignRankListViewModel

- (void)et_initialize {
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRankModel *model = [[ETRankModel alloc] initWithDictionary:dic error:nil];
                ETSignRankListTableViewCellViewModel *viewModel = [[ETSignRankListTableViewCellViewModel alloc] init];
                viewModel.likeClickSubject = self.likeClickSubject;
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
                ETSignRankListTableViewCellViewModel *viewModel = [[ETSignRankListTableViewCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.myCheckInCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            ETPKMyCheckInModel *model = [[ETPKMyCheckInModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.headerViewModel.model = model;
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
                PK_CheckIn_Early_List_Request *checkInListRequest = [[PK_CheckIn_Early_List_Request alloc] initWithPageIndex:self.currentPage PageSize:10];
                [checkInListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
                PK_CheckIn_Early_List_Request *checkInListRequest = [[PK_CheckIn_Early_List_Request alloc] initWithPageIndex:self.currentPage PageSize:10];
                [checkInListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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

- (RACCommand *)myCheckInCommand {
    if (!_myCheckInCommand) {
        _myCheckInCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_MyCheckIn_Get_Request *myCheckInRequest = [[PK_MyCheckIn_Get_Request alloc] init];
                [myCheckInRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _myCheckInCommand;
}

- (RACCommand *)likeSignCommand {
    if (!_likeSignCommand) {
        _likeSignCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *userID) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Likes_Add_Early_Request *likeEarlyRequest = [[PK_Likes_Add_Early_Request alloc] initWithToUserID:[userID integerValue]];
                [likeEarlyRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [subscriber sendNext:request.responseObject];
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
    return _likeSignCommand;
}

- (ETSignRankHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[ETSignRankHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

- (RACSubject *)likeClickSubject {
    if (!_likeClickSubject) {
        _likeClickSubject = [RACSubject subject];
    }
    return _likeClickSubject;
}

- (RACSubject *)headerCellClickSubject {
    if (!_headerCellClickSubject) {
        _headerCellClickSubject = [RACSubject subject];
    }
    return _headerCellClickSubject;
}

@end
