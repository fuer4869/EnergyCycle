//
//  ETOpinionViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETOpinionViewModel.h"
#import "Post_List_Request.h"
#import "Post_Del_Request.h"
#import "Post_Likes_Add_Request.h"

#import "ETOpinionTableViewCellViewModel.h"
#import "ETLogPostListTableViewCellViewModel.h"

#import "User_FirstEnter_Get_Request.h"
#import "User_FirstEnter_Upd_Request.h"

@interface ETOpinionViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETOpinionViewModel

- (void)et_initialize {
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
                viewModel.homePageSubject = self.homePageSubject;
                viewModel.postDeleteSubject = self.postDeleteSubject;
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
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
                viewModel.homePageSubject = self.homePageSubject;
                viewModel.postDeleteSubject = self.postDeleteSubject;
                viewModel.postLikeSubject = self.postLikeSubject;
                
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.firstEnterDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.firstEnterModel = [[ETFirstEnterModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.firstEnterEndSubject sendNext:nil];
        }
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
                @strongify(self);
                self.currentPage = 1;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETOpinionPost PageIndex:self.currentPage PageSize:15];
                [postListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETOpinionPost PageIndex:self.currentPage PageSize:15];
                [postListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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

- (RACCommand *)postDeleteCommand {
    if (!_postDeleteCommand) {
        @weakify(self)
        _postDeleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(ETLogPostListTableViewCellViewModel *viewModel) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                Post_Del_Request *delRequest = [[Post_Del_Request alloc] initWithPostID:[viewModel.model.PostID integerValue]];
                [delRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [subscriber sendNext:request.responseObject];
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
                        [array removeObject:viewModel];
                        self.dataArray = array;
                        [self.refreshEndSubject sendNext:nil];
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
    return _postDeleteCommand;
}

- (RACCommand *)postLikeCommand {
    if (!_postLikeCommand) {
//        @weakify(self)
        _postLikeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *postID) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                @strongify(self)
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


- (RACCommand *)firstEnterDataCommand {
    if (!_firstEnterDataCommand) {
//        @weakify(self)
        _firstEnterDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            @strongify(self)
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

- (RACSubject *)firstEnterEndSubject {
    if (!_firstEnterEndSubject) {
        _firstEnterEndSubject = [RACSubject subject];
    }
    return _firstEnterEndSubject;
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

- (RACSubject *)postDeleteSubject {
    if (!_postDeleteSubject) {
        _postDeleteSubject = [RACSubject subject];
    }
    return _postDeleteSubject;
}

- (RACSubject *)postLikeSubject {
    if (!_postLikeSubject) {
        _postLikeSubject = [RACSubject subject];
    }
    return _postLikeSubject;
}

@end
