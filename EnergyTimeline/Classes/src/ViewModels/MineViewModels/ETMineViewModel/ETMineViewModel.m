//
//  ETMineViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineViewModel.h"
#import "UserModel.h"
#import "User_UserInfo_GetByUserID_Request.h"
#import "Mine_Likes_Sta_Get_Request.h"
#import "Mine_Notice_NotReadCount_Num_Request.h"

#import "User_FirstEnter_Get_Request.h"
#import "User_FirstEnter_Upd_Request.h"

#import "File_Upload_Request.h"
#import "User_ProfilePicture_Edit_Request.h"

@implementation ETMineViewModel

- (void)et_initialize {
    @weakify(self)
    
    /** 用户信息 */
    [self.userDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.model = [[UserModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.refreshUserModelSubject sendNext:nil];
        }
    }];
    
    [self.myLikeCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.LikesNum = [responseObject[@"Data"][@"LikesNum"] stringValue];
            self.LikesRanking = [responseObject[@"Data"][@"LikesRanking"] stringValue];
            [self.refreshUserModelSubject sendNext:nil];
        }
    }];
    
    [self.noticeDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.noticeNotReadCount = [responseObject[@"Data"] integerValue];
            [self.refreshUserModelSubject sendNext:nil];
        }
    }];
    
    [self.uploadProfilePictureCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue]) {
            [self.userDataCommand execute:nil];
            NSLog(@"头像更换成功");
        }
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

- (RACCommand *)myLikeCommand {
    if (!_myLikeCommand) {
        _myLikeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Mine_Likes_Sta_Get_Request *likeRequest = [[Mine_Likes_Sta_Get_Request alloc] init];
                [likeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        User_Logout
//                        [MBProgressHUD showMessage:@"请登录"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _myLikeCommand;
}

- (RACSubject *)mineHomePageSubject {
    if (!_mineHomePageSubject) {
        _mineHomePageSubject = [RACSubject subject];
    }
    return _mineHomePageSubject;
}

- (RACSubject *)changeProfilePictureSubject {
    if (!_changeProfilePictureSubject) {
        _changeProfilePictureSubject = [RACSubject subject];
    }
    return _changeProfilePictureSubject;
}

- (RACSubject *)profilePictureSubject {
    if(!_profilePictureSubject) {
        _profilePictureSubject = [RACSubject subject];
    }
    return _profilePictureSubject;
}

- (RACSubject *)setupSubject {
    if (!_setupSubject) {
        _setupSubject = [RACSubject subject];
    }
    return _setupSubject;
}

- (RACSubject *)noticeSubject {
    if (!_noticeSubject) {
        _noticeSubject = [RACSubject subject];
    }
    return _noticeSubject;
}

- (RACSubject *)myInfoSubject {
    if (!_myInfoSubject) {
        _myInfoSubject = [RACSubject subject];
    }
    return _myInfoSubject;
}

- (RACSubject *)draftsSubject {
    if (!_draftsSubject) {
        _draftsSubject = [RACSubject subject];
    }
    return _draftsSubject;
}

- (RACSubject *)integralRecordSubject {
    if (!_integralRecordSubject) {
        _integralRecordSubject = [RACSubject subject];
    }
    return _integralRecordSubject;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

- (RACSubject *)firstEnterEndSubject {
    if (!_firstEnterEndSubject) {
        _firstEnterEndSubject = [RACSubject subject];
    }
    return _firstEnterEndSubject;
}

/** 用户信息 */
- (RACCommand *)userDataCommand {
    if (!_userDataCommand) {
        _userDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_UserInfo_GetByUserID_Request *userInfoRequest = [[User_UserInfo_GetByUserID_Request alloc] initWithUserID:0];
                [userInfoRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _userDataCommand;
}

/** 通知未读信息 */
- (RACCommand *)noticeDataCommand {
    if (!_noticeDataCommand) {
        _noticeDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Mine_Notice_NotReadCount_Num_Request *notReadRequest = [[Mine_Notice_NotReadCount_Num_Request alloc] init];
                [notReadRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:notReadRequest.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _noticeDataCommand;
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

- (RACSubject *)refreshUserModelSubject {
    if (!_refreshUserModelSubject) {
        _refreshUserModelSubject = [RACSubject subject];
    }
    return _refreshUserModelSubject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
