//
//  ETSearchViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSearchViewModel.h"
#import "UserModel.h"
#import "PostModel.h"
#import "User_Discover_UserInfo_List_Request.h"
#import "Post_List_Request.h"
#import "Post_Likes_Add_Request.h"
#import "ETSearchUserTableViewCellViewModel.h"
#import "ETLogPostListTableViewCellViewModel.h"
#import "User_Friend_Add_Request.h"

@interface ETSearchViewModel ()

@property (nonatomic, assign) NSInteger currentUserPage;
@property (nonatomic, assign) NSInteger currentPostPage;

@end

@implementation ETSearchViewModel

- (void)et_initialize {
    @weakify(self)
    [self.refreshUserDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                ETSearchUserTableViewCellViewModel *viewModel = [[ETSearchUserTableViewCellViewModel alloc] init];
                viewModel.attentionSubject = self.attentionSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.userDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.nextUserDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.userDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                ETSearchUserTableViewCellViewModel *viewModel = [[ETSearchUserTableViewCellViewModel alloc] init];
                viewModel.attentionSubject = self.attentionSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.userDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshPostDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
                viewModel.homePageSubject = self.homePageSubject;
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.postDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.nextPostDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.postDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
                viewModel.homePageSubject = self.homePageSubject;
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.postDataArray = array;
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

- (RACSubject *)dismissSubject {
    if (!_dismissSubject) {
        _dismissSubject = [RACSubject subject];
    }
    return _dismissSubject;
}

- (RACCommand *)refreshUserDataCommand {
    if (!_refreshUserDataCommand) {
        @weakify(self)
        _refreshUserDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentUserPage = 1;
                User_Discover_UserInfo_List_Request *userRequest = [[User_Discover_UserInfo_List_Request alloc] initWithSearchKey:self.searchKey PageIndex:self.currentUserPage PageSize:20];
                [userRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _refreshUserDataCommand;
}

- (RACCommand *)nextUserDataCommand {
    if (!_nextUserDataCommand) {
        @weakify(self)
        _nextUserDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentUserPage ++;
                User_Discover_UserInfo_List_Request *userRequest = [[User_Discover_UserInfo_List_Request alloc] initWithSearchKey:self.searchKey PageIndex:self.currentUserPage PageSize:3];
                [userRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _nextUserDataCommand;
}

- (RACCommand *)refreshPostDataCommand {
    if (!_refreshPostDataCommand) {
        @weakify(self)
        _refreshPostDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPostPage = 1;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETLogPost PageIndex:self.currentPostPage PageSize:10 SearchKey:self.searchKey];
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
    return _refreshPostDataCommand;
}

- (RACCommand *)nextPostDataCommand {
    if (!_nextPostDataCommand) {
        @weakify(self);
        _nextPostDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPostPage ++;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETLogPost PageIndex:self.currentPostPage PageSize:10 SearchKey:self.searchKey];
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
    return _nextPostDataCommand;
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

- (NSArray *)userDataArray {
    if (!_userDataArray) {
        _userDataArray = [[NSArray alloc] init];
    }
    return _userDataArray;
}

- (NSArray *)postDataArray {
    if (!_postDataArray) {
        _postDataArray = [[NSArray alloc] init];
    }
    return _postDataArray;
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

- (RACSubject *)postLikeSubject {
    if (!_postLikeSubject) {
        _postLikeSubject = [RACSubject subject];
    }
    return _postLikeSubject;
}

- (RACSubject *)userCellClickSubject {
    if (!_userCellClickSubject) {
        _userCellClickSubject = [RACSubject subject];
    }
    return _userCellClickSubject;
}

@end
