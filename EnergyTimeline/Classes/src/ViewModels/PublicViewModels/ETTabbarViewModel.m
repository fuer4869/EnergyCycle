//
//  ETTabbarViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/7/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETTabbarViewModel.h"
#import "Mine_Notice_NotReadCount_Num_Request.h"

@implementation ETTabbarViewModel

- (void)et_initialize {
    @weakify(self)

    [self.noticeDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.noticeNotReadCount = [responseObject[@"Data"] integerValue];
            [self.refreshEndSubject sendNext:nil];
        }
    }];
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

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)backListTopSubject {
    if (!_backListTopSubject) {
        _backListTopSubject = [RACSubject subject];
    }
    return _backListTopSubject;
}

@end
