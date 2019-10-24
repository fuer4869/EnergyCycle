//
//  ETHomePageViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePageViewModel.h"
#import "UserModel.h"
#import "PostModel.h"
#import "Post_List_Request.h"
#import "PK_Report_Post_Add.h"
#import "Post_Del_Request.h"
#import "Post_Likes_Add_Request.h"
#import "Mine_Report_List_UserID_Request.h"
#import "Mine_Report_List_Today_UserID_Request.h"

#import "User_UserInfo_GetByUserID_Request.h"

/** 头像和封面相关 */
#import "File_Upload_Request.h"
#import "User_CoverImg_Upd_Request.h"
#import "User_ProfilePicture_Edit_Request.h"

#import "ETLogPostListTableViewCellViewModel.h"
#import "ETPromisePostListTableViewCellViewModel.h"
#import "ETHomePagePKTableViewCellViewModel.h"

/** 添加关注 */
#import "User_Friend_Add_Request.h"

#import "ETPopView.h"

@interface ETHomePageViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

/** 普通帖子页数 */
@property (nonatomic, assign) NSInteger currentLogPage;
/** 公众承诺页数 */
@property (nonatomic, assign) NSInteger currentPromisePage;
/** 今日pk页数 */
//@property (nonatomic, assign) NSInteger currentPKPage;
/** pk记录页数 */
//@property (nonatomic, assign) NSInteger currentPKRecordPage;

@end

@implementation ETHomePageViewModel

- (void)et_initialize {
    @weakify(self)
    
    /** 普通帖子 */
    [self.refreshLogDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
                viewModel.postDeleteSubject = self.postDeleteSubject;
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.logDataArray = array;
        }
        [self.refreshLogEndSubject sendNext:nil];
    }];
    
    [self.nextLogPageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.logDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETLogPostListTableViewCellViewModel *viewModel = [[ETLogPostListTableViewCellViewModel alloc] init];
                viewModel.postDeleteSubject = self.postDeleteSubject;
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.logDataArray = array;
        }
        [self.refreshLogEndSubject sendNext:nil];
    }];
    
    /** 公众承诺 */
    [self.refreshPromiseDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETPromisePostListTableViewCellViewModel *viewModel = [ETPromisePostListTableViewCellViewModel alloc];
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.promiseDataArray = array;
        }
        [self.refreshPromiseEndSubject sendNext:nil];
    }];
    
    [self.nextPromisePageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.promiseDataArray];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostModel *model = [[PostModel alloc] initWithDictionary:dic error:nil];
                ETPromisePostListTableViewCellViewModel *viewModel = [[ETPromisePostListTableViewCellViewModel alloc] init];
                viewModel.postLikeSubject = self.postLikeSubject;
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.logDataArray = array;
        }
        [self.refreshPromiseEndSubject sendNext:nil];
    }];
    
    /** 今日PK */
    [self.refreshPKDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                ETHomePagePKTableViewCellViewModel *viewModel = [ETHomePagePKTableViewCellViewModel alloc];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.pkDataArray = array;
        }
        [self.refreshPKEndSubject sendNext:nil];
    }];
    
    /** PK记录 */
    [self.refreshPKRecordCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                ETHomePagePKTableViewCellViewModel *viewModel = [ETHomePagePKTableViewCellViewModel alloc];
                viewModel.model = model;
                [array addObject:viewModel];
            }
            self.pkRecordDataArray = array;
        }
        [self.refreshPKRecordEndSubject sendNext:nil];
    }];
    
    /** 用户信息相关 */
    [self.uploadCoverImgCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue]) {
            [self.userDataCommand execute:nil];

            NSLog(@"背景图片更换成功");
        }
    }];
    
    [self.uploadProfilePictureCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue]) {
            [self.userDataCommand execute:nil];
            NSLog(@"头像图片更换成功");
        }
    }];
    
    [self.userDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.model = [[UserModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.refreshUserModelSubject sendNext:nil];
        }
    }];
    
}

#pragma mark -- lazyLoad --

- (RACSubject *)refreshLogEndSubject {
    if (!_refreshLogEndSubject) {
        _refreshLogEndSubject = [RACSubject subject];
    }
    return _refreshLogEndSubject;
}

- (RACSubject *)refreshPromiseEndSubject {
    if (!_refreshPromiseEndSubject) {
        _refreshPromiseEndSubject = [RACSubject subject];
    }
    return _refreshPromiseEndSubject;
}

- (RACSubject *)refreshPKEndSubject {
    if (!_refreshPKEndSubject) {
        _refreshPKEndSubject = [RACSubject subject];
    }
    return _refreshPKEndSubject;
}

- (RACSubject *)refreshPKRecordEndSubject {
    if (!_refreshPKRecordEndSubject) {
        _refreshPKRecordEndSubject = [RACSubject subject];
    }
    return _refreshPKRecordEndSubject;
}

- (RACSubject *)refreshUserModelSubject {
    if (!_refreshUserModelSubject) {
        _refreshUserModelSubject = [RACSubject subject];
    }
    return _refreshUserModelSubject;
}

/** 滑动代理 */
- (RACSubject *)scrollViewSubject {
    if (!_scrollViewSubject) {
        _scrollViewSubject = [RACSubject subject];
    }
    return _scrollViewSubject;
}

- (RACSubject *)leaveFromTopSubject {
    if (!_leaveFromTopSubject) {
        _leaveFromTopSubject = [RACSubject subject];
    }
    return _leaveFromTopSubject;
}

/** 普通帖子 */
- (RACCommand *)refreshLogDataCommand {
    if (!_refreshLogDataCommand) {
        @weakify(self)
        _refreshLogDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentLogPage = 1;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETUserLogPost PageIndex:self.currentLogPage PageSize:10 FromUserID:self.userID];
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
    return _refreshLogDataCommand;
}

- (RACCommand *)nextLogPageCommand {
    if (!_nextLogPageCommand) {
        @weakify(self)
        _nextLogPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentLogPage ++;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETUserLogPost PageIndex:self.currentLogPage PageSize:10 FromUserID:self.userID];
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
    return _nextLogPageCommand;
}

- (NSArray *)logDataArray {
    if (!_logDataArray) {
        _logDataArray = [[NSArray alloc] init];
    }
    return _logDataArray;
}

/** 公众承诺 */
- (RACCommand *)refreshPromiseDataCommand {
    if (!_refreshPromiseDataCommand) {
        @weakify(self)
        _refreshPromiseDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPromisePage = 1;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETUserPromisePost PageIndex:self.currentPromisePage PageSize:10 FromUserID:self.userID];
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
    return _refreshPromiseDataCommand;
}

- (RACCommand *)nextPromisePageCommand {
    if (!_nextPromisePageCommand) {
        @weakify(self)
        _nextPromisePageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPromisePage ++;
                Post_List_Request *postListRequest = [[Post_List_Request alloc] initWithType:ETUserPromisePost PageIndex:self.currentPromisePage PageSize:10 FromUserID:self.userID];
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
    return _nextPromisePageCommand;
}

- (NSArray *)promiseDataArray {
    if (!_promiseDataArray) {
        _promiseDataArray = [[NSArray alloc] init];
    }
    return _promiseDataArray;
}

/** 今日PK */
- (RACCommand *)refreshPKDataCommand {
    if (!_refreshPKDataCommand) {
        @weakify(self)
        _refreshPKDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                Mine_Report_List_Today_UserID_Request *todayRequest = [[Mine_Report_List_Today_UserID_Request alloc] initWithUserID:self.userID];
                [todayRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _refreshPKDataCommand;
}

- (NSArray *)pkDataArray {
    if (!_pkDataArray) {
        _pkDataArray = [[NSArray alloc] init];
    }
    return _pkDataArray;
}

/** PK记录 */
- (RACCommand *)refreshPKRecordCommand {
    if (!_refreshPKRecordCommand) {
        @weakify(self)
        _refreshPKRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                Mine_Report_List_UserID_Request *reportRequest = [[Mine_Report_List_UserID_Request alloc] initWithUserID:self.userID];
                [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _refreshPKRecordCommand;
}

- (NSArray *)pkRecordDataArray {
    if (!_pkRecordDataArray) {
        _pkRecordDataArray = [[NSArray alloc] init];
    }
    return _pkRecordDataArray;
}

- (RACSubject *)pkRecordCellClickSubject {
    if (!_pkRecordCellClickSubject) {
        _pkRecordCellClickSubject = [RACSubject subject];
    }
    return _pkRecordCellClickSubject;
}

/** 帖子相关 */

#pragma mark -- 暂时弃用 --
- (RACCommand *)pkReportCommand {
    if (!_pkReportCommand) {
        _pkReportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Report_Post_Add *reportRequest = [[PK_Report_Post_Add alloc] init];
                [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        if ([request.responseObject[@"Data"] integerValue]) {
                            [ETPopView popViewWithTip:@"汇报成功"];
                        } else {
                            [ETPopView popViewWithTip:@"请汇报更多PK项目"];
                        }
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
    return _pkReportCommand;
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
                        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.logDataArray];
                        [array removeObject:viewModel];
                        self.logDataArray = array;
                        [self.refreshLogEndSubject sendNext:nil];
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

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
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

/** 用户信息相关 */

- (RACSubject *)attentionListSubject {
    if (!_attentionListSubject) {
        _attentionListSubject = [RACSubject subject];
    }
    return _attentionListSubject;
}

- (RACSubject *)fansListSubject {
    if (!_fansListSubject) {
        _fansListSubject = [RACSubject subject];
    }
    return _fansListSubject;
}

- (RACSubject *)messageSubject {
    if (!_messageSubject) {
        _messageSubject = [RACSubject subject];
    }
    return _messageSubject;
}

- (RACSubject *)attentionSubject {
    if (!_attentionSubject) {
        _attentionSubject = [RACSubject subject];
    }
    return _attentionSubject;
}

- (RACSubject *)setCoverImgSubject {
    if (!_setCoverImgSubject) {
        _setCoverImgSubject = [RACSubject subject];
    }
    return _setCoverImgSubject;
}

- (RACSubject *)setProfilePictureSubject {
    if (!_setProfilePictureSubject) {
        _setProfilePictureSubject = [RACSubject subject];
    }
    return _setProfilePictureSubject;
}


- (RACCommand *)uploadFileCommand {
    if (!_uploadFileCommand) {
        _uploadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *imageData) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [File_Upload_Request uploadWithImageData:imageData success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [MBProgressHUD showMessage:@"图片上传失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _uploadFileCommand;
}

- (RACCommand *)uploadCoverImgCommand {
    if (!_uploadCoverImgCommand) {
        @weakify(self)
        _uploadCoverImgCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *imageData) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [[self.uploadFileCommand execute:imageData] subscribeNext:^(id responseObject) {
                    if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
                        User_CoverImg_Upd_Request *coverImgRequest = [[User_CoverImg_Upd_Request alloc] initWithFileID:[responseObject[@"Data"][0] integerValue]];
                        [coverImgRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                            [subscriber sendNext:request.responseObject];
                            [subscriber sendCompleted];
                        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                            [MBProgressHUD showMessage:@"图片上传失败"];
                            [subscriber sendCompleted];
                        }];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _uploadCoverImgCommand;
}

- (RACCommand *)uploadProfilePictureCommand {
    if (!_uploadProfilePictureCommand) {
        @weakify(self)
        _uploadProfilePictureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *imageData) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [[self.uploadFileCommand execute:imageData] subscribeNext:^(id responseObject) {
                    if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
                        User_ProfilePicture_Edit_Request *profilePictureRequest = [[User_ProfilePicture_Edit_Request alloc] initWithFileID:[responseObject[@"Data"][0] integerValue]];
                        [profilePictureRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                            [subscriber sendNext:request.responseObject];
                            [subscriber sendCompleted];
                        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                            [MBProgressHUD showMessage:@"图片上传失败"];
                            [subscriber sendCompleted];
                        }];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _uploadProfilePictureCommand;
}

- (RACCommand *)userDataCommand {
    if (!_userDataCommand) {
        @weakify(self)
        _userDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                User_UserInfo_GetByUserID_Request *userInfoRequest = [[User_UserInfo_GetByUserID_Request alloc] initWithUserID:self.userID];
                [userInfoRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _userDataCommand;
}

- (RACCommand *)attentionCommand {
    if (!_attentionCommand) {
        _attentionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_Friend_Add_Request *friendRequest = [[User_Friend_Add_Request alloc] initWithFriendUserID:self.userID];
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

- (void)setUserID:(NSInteger)userID {
    if (userID == [User_ID integerValue] || userID == 0) {
        self.isOtherUser = NO;
    } else {
        self.isOtherUser = YES;
    }
    _userID = userID;
}

#pragma mark -- private --

- (id)initWithUserID:(NSInteger)userID {
    if (self = [super init]) {
        self.userID = userID;
        [self.userDataCommand execute:nil];
    }
    return self;
}



@end
