//
//  ETLoginViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLoginViewModel.h"
#import "HashCode_Request.h"
#import "PhoneCode_Get_Request.h"
#import "Login_Request.h"
#import "UserModel.h"
#import "ShareSDKManager.h"

#import "ETHealthManager.h"

#import "JPUSHService.h"

@implementation ETLoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        @weakify(self)
        self.validVerificationCodeSignal = [[RACSignal combineLatest:@[RACObserve(self, phoneNumber)] reduce:^(NSString *phoneNumber){
            return @(phoneNumber.jk_isMobileNumber);
        }] distinctUntilChanged];
        
        self.validLoginSignal = [[RACSignal combineLatest:@[RACObserve(self, phoneNumber), RACObserve(self, verificationCode)] reduce:^(NSString *phoneNumber, NSString *verificationCode){
            return @(phoneNumber.jk_isMobileNumber && verificationCode.length >= 4);
        }] distinctUntilChanged];
        
        self.verigicationCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                PhoneCode_Get_Request *phoneCodeRequest = [[PhoneCode_Get_Request alloc] initWithPhoneNo:self.phoneNumber type:2 VerificationCode:User_HashCode];
                [phoneCodeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                }];
                return nil;
            }];
        }];
        
        self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                Login_Request *loginRequest = [[Login_Request alloc] initWithLoginName:self.phoneNumber Code:[self.verificationCode integerValue]];
                [loginRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        UserModel *model = [[UserModel alloc] initWithDictionary:request.responseObject[@"Data"] error:nil];
                        [[NSUserDefaults standardUserDefaults] setObject:model.UserID forKey:@"USERID"];
                        [[NSUserDefaults standardUserDefaults] setObject:model.NickName forKey:@"NICKNAME"];
                        [[NSUserDefaults standardUserDefaults] setObject:model.Ticket forKey:@"TICKET"];
                        [[NSUserDefaults standardUserDefaults] setObject:model.Role forKey:@"ROLE"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [JPUSHService setTags:[NSSet setWithObject:[NSString stringWithFormat:@"ET_iOS_%@", model.UserID]] alias:[NSString stringWithFormat:@"ET_%@", model.UserID] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                            NSLog(@"tags is %@, alias is %@", iTags, iAlias);
                        }];
//                        [[ETHealthManager sharedInstance] stepAutomaticUpload];
                    }
                    [subscriber sendNext:request.responseObject];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                }];
                return nil;
            }];
        }];
        
        
    }
    return self;
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

- (RACCommand *)thirdLoginCommand {
    if (!_thirdLoginCommand) {
        _thirdLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *userDic) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Login_Request *loginRequest = [[Login_Request alloc] initWithLoginType:[userDic[@"LoginType"] integerValue] OpenID:userDic[@"OpenID"] NickName:userDic[@"NickName"] ProfilePicture:userDic[@"ProfilePicture"]];
                [loginRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        UserModel *model = [[UserModel alloc] initWithDictionary:request.responseObject[@"Data"] error:nil];
                        [[NSUserDefaults standardUserDefaults] setObject:model.UserID forKey:@"USERID"];
                        [[NSUserDefaults standardUserDefaults] setObject:model.NickName forKey:@"NICKNAME"];
                        [[NSUserDefaults standardUserDefaults] setObject:model.Ticket forKey:@"TICKET"];
                        [[NSUserDefaults standardUserDefaults] setObject:model.Role forKey:@"ROLE"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [JPUSHService setTags:[NSSet setWithObject:[NSString stringWithFormat:@"ET_iOS_%@", model.UserID]] alias:[NSString stringWithFormat:@"ET_%@", model.UserID] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                            NSLog(@"tags is %@, alias is %@", iTags, iAlias);
                        }];
//                        [[ETHealthManager sharedInstance] stepAutomaticUpload];
                    }
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"登录失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _thirdLoginCommand;
}

@end
