//
//  ETLogPostListViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLogPostListViewModel.h"
#import "PostModel.h"
#import "UserModel.h"
#import "Post_List_Request.h"
#import "Post_Del_Request.h"
#import "User_Hot_List_Request.h"
#import "Post_Likes_Add_Request.h"
#import "User_Friend_Add_Request.h"
#import "ETLogPostListTableViewCellViewModel.h"
#import "ETLogPostListCollectionCellViewModel.h"

#import "ETHealthManager.h"

@interface ETLogPostListViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETLogPostListViewModel

- (void)et_initialize {
    
    [[ETHealthManager sharedInstance] stepAutomaticUpload];
    
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
    
    [self.refreshHeaderDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                ETLogPostListCollectionCellViewModel *viewModel = [[ETLogPostListCollectionCellViewModel alloc] init];
                viewModel.attentionSubject = self.attentionSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.headerViewModel.dataArray = array;
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
                @strongify(self);
                self.currentPage = 1;
                [self.refreshHeaderDataCommand execute:nil];
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETLogPost PageIndex:self.currentPage PageSize:10];
                [postListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请重新登录"];
                    } else {
                        [MBProgressHUD showMessage:@"网络连接失败"];
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
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETLogPost PageIndex:self.currentPage PageSize:10];
                [postListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请重新登录"];
                    } else {
                        [MBProgressHUD showMessage:@"网络连接失败"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageCommand;
}

- (RACCommand *)refreshHeaderDataCommand {
    if (!_refreshHeaderDataCommand) {
        _refreshHeaderDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_Hot_List_Request *userHotRequest = [[User_Hot_List_Request alloc] init];
                [userHotRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshHeaderDataCommand;
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
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请重新登录"];
                    } else {
                        [MBProgressHUD showMessage:@"网络连接失败"];
                    }
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
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请重新登录"];
                    } else {
                        [MBProgressHUD showMessage:@"网络连接失败"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _postLikeCommand;
}

- (ETLogPostListHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[ETLogPostListHeaderViewModel alloc] init];
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
