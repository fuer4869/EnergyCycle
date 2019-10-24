//
//  ETPhoneNoChangeViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPhoneNoChangeViewModel.h"
#import "HashCode_Request.h"
#import "PhoneCode_Get_Request.h"
#import "Mine_Phone_Change_Request.h"

@implementation ETPhoneNoChangeViewModel

- (void)et_initialize {
    self.validVerificationCodeSignal = [[RACSignal combineLatest:@[RACObserve(self, phoneNumber)] reduce:^(NSString *phoneNumber){
        return @(phoneNumber.jk_isMobileNumber);
    }] distinctUntilChanged];
    
    self.validChangeSignal = [[RACSignal combineLatest:@[RACObserve(self, phoneNumber), RACObserve(self, verificationCode)] reduce:^(NSString *phoneNumber, NSString *verificationCode){
        return @(phoneNumber.jk_isMobileNumber && verificationCode.length == 4);
    }] distinctUntilChanged];
    
    [self.phoneNoChangeCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue] == 200) {
            [self.changeEndSubject sendNext:nil];
        }
    }];
}

- (RACCommand *)hashCodeCommand {
    if (!_hashCodeCommand) {
        _hashCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                HashCode_Request *hashCodeRequest = [[HashCode_Request alloc] init];
                [hashCodeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    NSString *hashCode = [[request.responseObject[@"Data"] jk_md5String] jk_md5String];
                    [[NSUserDefaults standardUserDefaults] setObject:hashCode forKey:@"HASHCODE"];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _hashCodeCommand;
}

- (RACCommand *)verigicationCodeCommand {
    if (!_verigicationCodeCommand) {
        @weakify(self)
        _verigicationCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                PhoneCode_Get_Request *phoneCodeRequest = [[PhoneCode_Get_Request alloc] initWithPhoneNo:self.phoneNumber type:4 VerificationCode:User_HashCode];
                [phoneCodeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _verigicationCodeCommand;
}

- (RACCommand *)phoneNoChangeCommand {
    if (!_phoneNoChangeCommand) {
        @weakify(self)
        _phoneNoChangeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                Mine_Phone_Change_Request *changeRequest = [[Mine_Phone_Change_Request alloc] initWithPhoneNo:self.phoneNumber Code:[self.verificationCode integerValue]];
                [changeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.error];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _phoneNoChangeCommand;
}

@end
