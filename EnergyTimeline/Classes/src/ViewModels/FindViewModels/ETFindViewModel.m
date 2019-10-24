//
//  ETFindViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETFindViewModel.h"
#import "ETBannerModel.h"
#import "Find_Banner_List_Request.h"

#import "PostModel.h"
#import "Post_List_Request.h"
#import "Post_Del_Request.h"
#import "Post_Likes_Add_Request.h"
#import "ETLogPostListTableViewCellViewModel.h"

@interface ETFindViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ETFindViewModel

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
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.postDeleteSubject = self.postDeleteSubject;
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
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.postDeleteSubject = self.postDeleteSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.bannerCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *topArray = [[NSMutableArray alloc] init];
            NSMutableArray *bottomArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETBannerModel *model = [[ETBannerModel alloc] initWithDictionary:dic error:nil];
                if ([model.ViewArea isEqualToString:@"1"]) {
                    [topArray addObject:model];
                } else {
                    [bottomArray addObject:model];
                }
            }
            self.topBannerArray = topArray;
            self.bottomBannerArray = bottomArray;
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
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETRecommendPost PageIndex:self.currentPage PageSize:10];
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
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETRecommendPost PageIndex:self.currentPage PageSize:10];
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

- (RACCommand *)bannerCommand {
    if (!_bannerCommand) {
        _bannerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Find_Banner_List_Request *bannerRequest = [[Find_Banner_List_Request alloc] init];
                [bannerRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _bannerCommand;
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

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (RACSubject *)searchSubject {
    if (!_searchSubject) {
        _searchSubject = [RACSubject subject];
    }
    return _searchSubject;
}

//- (RACSubject *)bannerCellClickSubjet {
//    if (!_bannerCellClickSubjet) {
//        _bannerCellClickSubjet = [RACSubject subject];
//    }
//    return _bannerCellClickSubjet;
//}

- (RACSubject *)topBannerCellClickSubjet {
    if (!_topBannerCellClickSubjet) {
        _topBannerCellClickSubjet = [RACSubject subject];
    }
    return _topBannerCellClickSubjet;
}

- (RACSubject *)bottomBannerCellClickSubject {
    if (!_bottomBannerCellClickSubject) {
        _bottomBannerCellClickSubject = [RACSubject subject];
    }
    return _bottomBannerCellClickSubject;
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

- (RACSubject *)postDeleteSubject {
    if (!_postDeleteSubject) {
        _postDeleteSubject = [RACSubject subject];
    }
    return _postDeleteSubject;
}

@end
