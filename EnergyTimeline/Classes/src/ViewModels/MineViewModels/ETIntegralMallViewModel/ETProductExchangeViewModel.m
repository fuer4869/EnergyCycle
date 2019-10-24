//
//  ETProductExchangeViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProductExchangeViewModel.h"
#import "Mine_Product_Exchange_Add_Request.h"

@implementation ETProductExchangeViewModel

- (void)et_initialize {
    @weakify(self)
    [self.exchangeCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [self.exchangeEndSubject sendNext:nil];
        }
    }];
}

#pragma mark -- lazyLoad --

- (RACSignal *)exchangeEnableSignal {
    if (!_exchangeEnableSignal) {
        _exchangeEnableSignal = [RACSignal combineLatest:@[RACObserve(self, receiver), RACObserve(self, receivePhone), RACObserve(self, receiveAddress)] reduce:^id(NSString *receiver, NSString *receivePhone, NSString *receiveAddress){
            return @(receiver.length && receivePhone.length && receiveAddress.length);
        }];
    }
    return _exchangeEnableSignal;
}

- (RACCommand *)exchangeCommand {
    if (!_exchangeCommand) {
        @weakify(self)
        _exchangeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Mine_Product_Exchange_Add_Request *exchangeRequest = [[Mine_Product_Exchange_Add_Request alloc] initWithProductID:self.productID Receiver:self.receiver ReceivePhone:self.receivePhone ReceiveAddress:self.receiveAddress];
                [exchangeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
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
    return _exchangeCommand;
}

- (RACSubject *)exchangeEndSubject {
    if (!_exchangeEndSubject) {
        _exchangeEndSubject = [RACSubject subject];
    }
    return _exchangeEndSubject;
}

- (RACSubject *)exchangeSubject {
    if (!_exchangeSubject) {
        _exchangeSubject = [RACSubject subject];
    }
    return _exchangeSubject;
}

@end
