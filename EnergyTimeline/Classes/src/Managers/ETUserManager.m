//
//  ETUserManager.m
//  能量圈
//
//  Created by 王斌 on 2017/7/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUserManager.h"
#import "Logout_Request.h"

#import "JPUSHService.h"

@implementation ETUserManager

/** 单例 */
+ (id)sharedInstance {
    static ETUserManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ETUserManager alloc] init];
    });
    return manager;
}

- (void)logout {
    @weakify(self)
    [[self.logoutCommand execute:nil] subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                NSLog(@"取消推送");
            }];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USERID"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"TICKET"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ROLE"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"NICKNAME"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [self.logoutEndSubject sendNext:nil];
    }];
    NSLog(@"退出登录");
}

#pragma mark -- lazyLoad --

- (RACCommand *)logoutCommand {
    if (!_logoutCommand) {
        _logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Logout_Request *logoutRequest = [[Logout_Request alloc] init];
                [logoutRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    NSLog(@"退出登录报错");
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _logoutCommand;
}

@end
