//
//  ETUserInfoViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/10/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUserInfoViewModel.h"
#import "User_UserInfo_GetByUserID_Request.h"
#import "User_UserInfo_Edit_Request.h"

#import "File_Upload_Request.h"
#import "User_ProfilePicture_Edit_Request.h"

@implementation ETUserInfoViewModel

- (void)et_initialize {
    @weakify(self)
    /** 获取用户信息 */
    [self.userDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.model = [[UserModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.refreshUserModelSubject sendNext:nil];
        }
    }];
    
    [self.uploadProfilePictureCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue]) {
            [self.refreshUserModelSubject sendNext:nil];
            NSLog(@"头像更换成功");
        }
    }];
    
    /** 修改个人资料 */
    [self.editInfoCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [self.editEndSubject sendNext:nil];
        }
    }];
}

#pragma mark -- lazyLoad --

- (RACSubject *)refreshUserModelSubject {
    if (!_refreshUserModelSubject) {
        _refreshUserModelSubject = [RACSubject subject];
    }
    return _refreshUserModelSubject;
}

- (RACSubject *)editEndSubject {
    if (!_editEndSubject) {
        _editEndSubject = [RACSubject subject];
    }
    return _editEndSubject;
}

- (RACSubject *)profilePictureSubject {
    if (!_profilePictureSubject) {
        _profilePictureSubject = [RACSubject subject];
    }
    return _profilePictureSubject;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

/** 获取用户信息 */
- (RACCommand *)userDataCommand {
    if (!_userDataCommand) {
        _userDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_UserInfo_GetByUserID_Request *userInfoRequest = [[User_UserInfo_GetByUserID_Request alloc] initWithUserID:0];
                [userInfoRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _userDataCommand;
}

/** 上传文件 */
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

/** 更换头像 */
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

/** 修改个人资料 */
- (RACCommand *)editInfoCommand {
    if (!_editInfoCommand) {
        @weakify(self)
        _editInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                User_UserInfo_Edit_Request *editRequest = [[User_UserInfo_Edit_Request alloc] initWithUserID:[User_ID integerValue] NickName:self.model.NickName UserName:self.model.UserName Birthday:self.model.Birthday Gender:[self.model.Gender integerValue] Email:self.model.Email Brief:self.model.Brief];
                [editRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _editInfoCommand;
}



@end
