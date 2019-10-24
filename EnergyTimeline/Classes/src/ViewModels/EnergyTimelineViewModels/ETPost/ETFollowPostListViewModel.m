//
//  ETFollowPostListViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETFollowPostListViewModel.h"
#import "PostModel.h"
#import "Post_List_Request.h"
#import "Post_Likes_Add_Request.h"
#import "ETLogPostListTableViewCellViewModel.h"
#import "ETPromisePostListTableViewCellViewModel.h"

@interface ETFollowPostListViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETFollowPostListViewModel

- (void)et_initialize {
    
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                if ([model.PostType integerValue] == 3) {
                    ETPromisePostListTableViewCellViewModel *viewModel = [[ETPromisePostListTableViewCellViewModel alloc] init];
                    viewModel.homePageSubject = self.homePageSubject;
                    viewModel.postLikeSubject = self.postLikeSubject;
                    viewModel.model = model;
                    [array addObject:viewModel];
                }
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
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
                if ([model.PostType integerValue] == 3) {
                    ETPromisePostListTableViewCellViewModel *viewModel = [[ETPromisePostListTableViewCellViewModel alloc] init];
                    viewModel.homePageSubject = self.homePageSubject;
                    viewModel.postLikeSubject = self.postLikeSubject;
                    viewModel.model = model;
                    [array addObject:viewModel];
                }
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
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

#pragma mark -- lazyLoad --

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject =[RACSubject subject];
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
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETFollowPost PageIndex:self.currentPage PageSize:10];
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
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETFollowPost PageIndex:self.currentPage PageSize:10];
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
