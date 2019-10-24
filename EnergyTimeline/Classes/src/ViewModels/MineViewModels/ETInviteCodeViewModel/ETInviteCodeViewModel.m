//
//  ETInviteCodeViewModel.m
//  能量圈
//
//  Created by 王斌 on 2018/2/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETInviteCodeViewModel.h"
#import "User_Invite_Bind_Request.h"

@implementation ETInviteCodeViewModel

- (void)et_initialize {
//    @weakify(self)
    
    [self.inviteCodeCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
//        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [MBProgressHUD showMessage:responseObject[@"Data"]];
        }
    }];
}

#pragma mark -- lazyLoad --

- (RACCommand *)inviteCodeCommand {
    if (!_inviteCodeCommand) {
        _inviteCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_Invite_Bind_Request *inviteRequest = [[User_Invite_Bind_Request alloc] initWithInviteCode:self.inviteCode];
                [inviteRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _inviteCodeCommand;
}

@end
