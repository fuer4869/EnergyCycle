//
//  ETPromisePostListViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPromisePostListViewModel.h"
#import "PostModel.h"
#import "PromiseModel.h"
#import "Post_List_Request.h"
#import "Post_Likes_Add_Request.h"
#import "PK_My_Target_List_Request.h"
#import "ETPromisePostListTableViewCellViewModel.h"
#import "ETPromisePostListCollectionCellViewModel.h"

@interface ETPromisePostListViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETPromisePostListViewModel

- (void)et_initialize {
    
    @weakify(self)
    [self.refreshHeaderDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PromiseModel *model = [[PromiseModel alloc] initWithDictionary:dic error:nil];
                ETPromisePostListCollectionCellViewModel *viewModel = [[ETPromisePostListCollectionCellViewModel alloc] init];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.headerViewModel.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self);
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETPromisePostListTableViewCellViewModel *viewModel = [[ETPromisePostListTableViewCellViewModel alloc] init];
                viewModel.homePageSubject = self.homePageSubject;
                viewModel.postLikeSubject = self.postLikeSubject;
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
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETPromisePostListTableViewCellViewModel *viewModel = [[ETPromisePostListTableViewCellViewModel alloc] init];
                viewModel.homePageSubject = self.homePageSubject;
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
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
                [self.refreshHeaderDataCommand execute:nil];
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETPromisePost PageIndex:self.currentPage PageSize:10];
                [postListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [MBProgressHUD showMessage:@"请求失败"];
                    NSLog(@"%@", request.error);
                    if (request.responseStatusCode == 401) {
                        User_Logout
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshDataCommand;
}

- (RACCommand *)refreshHeaderDataCommand {
    if (!_refreshHeaderDataCommand) {
        _refreshHeaderDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_My_Target_List_Request *myTargetRequest = [[PK_My_Target_List_Request alloc] initWithType:1 PageIndex:1 PageSize:100];
                [myTargetRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [MBProgressHUD showMessage:@"请求失败"];
                    NSLog(@"%@", request.error);
                    if (request.responseStatusCode == 401) {
                        User_Logout
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshHeaderDataCommand;
}

- (RACCommand *)nextPageCommand {
    if (!_nextPageCommand) {
        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                self.currentPage ++;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETPromisePost PageIndex:self.currentPage PageSize:10];
                [postListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageCommand;
}

- (RACCommand *)postLikeCommand {
    if (!_postLikeCommand) {
        _postLikeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *postID) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Post_Likes_Add_Request *likeRequest = [[Post_Likes_Add_Request alloc] initWithPostID:[postID integerValue]];
                [likeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        NSLog(@"点赞成功");
                    }
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _postLikeCommand;
}

- (ETPromisePostListHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[ETPromisePostListHeaderViewModel alloc] init];
        _headerViewModel.refreshEndSubject = self.refreshEndSubject;
        _headerViewModel.cellClickSubject = self.headerCellClickSubject;
    }
    return _headerViewModel;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (RACSubject *)backListTopSubject {
    if (!_backListTopSubject) {
        _backListTopSubject = [RACSubject subject];
    }
    return _backListTopSubject;
}

- (RACSubject *)headerCellClickSubject {
    if (!_headerCellClickSubject) {
        _headerCellClickSubject = [RACSubject subject];
    }
    return _headerCellClickSubject;
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

- (RACSubject *)postLikeSubject {
    if (!_postLikeSubject) {
        _postLikeSubject = [RACSubject subject];
    }
    return _postLikeSubject;
}

@end
