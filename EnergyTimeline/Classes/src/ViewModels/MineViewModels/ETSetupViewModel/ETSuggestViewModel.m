//
//  ETSuggestViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSuggestViewModel.h"
#import "Mine_Suggest_Add_Request.h"
#import "ETPopView.h"

@implementation ETSuggestViewModel

- (void)et_initialize {
    @weakify(self)
    [self.suggestCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [ETPopView popViewWithTitle:@"反馈成功" Tip:@"感谢您对我们的宝贵建议!"];
            [self.suggestEndSubject sendNext:nil];
        }
    }];
}

- (RACSubject *)suggestEndSubject {
    if (!_suggestEndSubject) {
        _suggestEndSubject = [RACSubject subject];
    }
    return _suggestEndSubject;
}

- (RACCommand *)suggestCommand {
    if (!_suggestCommand) {
        @weakify(self)
        _suggestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                Mine_Suggest_Add_Request *suggestRequest = [[Mine_Suggest_Add_Request alloc] initWithSuggestContent:self.suggest];
                [suggestRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    NSLog(@"%@", request.error);
                    if (request.responseStatusCode == 401) {
                        User_Logout
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _suggestCommand;
}

@end
