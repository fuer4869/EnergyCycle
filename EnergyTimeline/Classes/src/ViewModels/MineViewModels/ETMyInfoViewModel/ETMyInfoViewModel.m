//
//  ETMyInfoViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMyInfoViewModel.h"
#import "User_UserInfo_Edit_Request.h"
#import "User_UserInfo_GetByUserID_Request.h"

@interface ETMyInfoViewModel ()

@property (nonatomic, assign) NSInteger userID;

@end

@implementation ETMyInfoViewModel

- (void)et_initialize {
    @weakify(self)
    /** 获取用户信息 */
    [self.userDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.infoModel.model = [[UserModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.refreshUserModelSubject sendNext:nil];
        }
    }];
    
    /** 修改用户信息 */
    [self.editInfoCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [self.editSuccessSubject sendNext:nil];
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

- (RACSubject *)editSuccessSubject {
    if (!_editSuccessSubject) {
        _editSuccessSubject = [RACSubject subject];
    }
    return _editSuccessSubject;
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
                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _userDataCommand;
}

/** 修改用户信息 */
- (RACCommand *)editInfoCommand {
    if (!_editInfoCommand) {
        @weakify(self)
        _editInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                User_UserInfo_Edit_Request *editUserRequest = [[User_UserInfo_Edit_Request alloc] initWithUserID:[User_ID integerValue] NickName:self.infoModel.model.NickName UserName:self.infoModel.model.UserName Birthday:self.infoModel.model.Birthday Gender:[self.infoModel.model.Gender integerValue] Email:self.infoModel.model.Email Brief:self.infoModel.model.Brief];
                [editUserRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _editInfoCommand;
}

- (ETMyInfoTableViewCellViewModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[ETMyInfoTableViewCellViewModel alloc] init];
    }
    return _infoModel;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

- (RACSubject *)cancelSubject {
    if (!_cancelSubject) {
        _cancelSubject = [RACSubject subject];
    }
    return _cancelSubject;
}

@end
