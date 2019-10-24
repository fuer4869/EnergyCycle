//
//  ETNewFansListViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNewFansListViewModel.h"
#import "User_Friend_Add_Request.h"
#import "User_Attention_Me_List_Request.h"

@interface ETNewFansListViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETNewFansListViewModel

- (void)et_initialize {
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                ETNewFansListTableViewCellViewModel *viewModel = [[ETNewFansListTableViewCellViewModel alloc] init];
                viewModel.model = model;
                viewModel.attentionSubject = self.attentionSubject;
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
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                ETNewFansListTableViewCellViewModel *viewModel = [[ETNewFansListTableViewCellViewModel alloc] init];
                viewModel.model = model;
                viewModel.attentionSubject = self.attentionSubject;
                [array addObject:viewModel];
            }
            self.dataArray = array;
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

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPage = 1;
                User_Attention_Me_List_Request *newFansListRequest = [[User_Attention_Me_List_Request alloc] initWithType:ETNewFans ToUserID:0 PageIndex:self.currentPage PageSize:10];
                [newFansListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
                self.currentPage ++;
                User_Attention_Me_List_Request *newFansListRequest = [[User_Attention_Me_List_Request alloc] initWithType:ETNewFans ToUserID:0 PageIndex:self.currentPage PageSize:10];
                [newFansListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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

- (RACCommand *)attentionCommand {
    if (!_attentionCommand) {
        _attentionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *userID) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_Friend_Add_Request *friendRequest = [[User_Friend_Add_Request alloc] initWithFriendUserID:[userID integerValue]];
                [friendRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        NSLog(@"Status 200");
                    }
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"关注失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _attentionCommand;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (RACSubject *)attentionSubject {
    if (!_attentionSubject) {
        _attentionSubject = [RACSubject subject];
    }
    return _attentionSubject;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

@end
