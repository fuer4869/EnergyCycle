//
//  ETNoticeCenterViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/11/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNoticeCenterViewModel.h"
#import "Mine_Notice_NotRead_Num_Request.h"

@implementation ETNoticeCenterViewModel

- (void)et_initialize {
    @weakify(self)
    [self.noticeDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.model = [[NoticeNotReadModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.refreshEndSubject sendNext:nil];
        }
    }];
}


- (RACCommand *)noticeDataCommand {
    if (!_noticeDataCommand) {
        _noticeDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Mine_Notice_NotRead_Num_Request *numRequest = [[Mine_Notice_NotRead_Num_Request alloc] init];
                [numRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _noticeDataCommand;
}

@end
