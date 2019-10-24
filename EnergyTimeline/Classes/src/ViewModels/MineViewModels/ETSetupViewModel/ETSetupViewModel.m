//
//  ETSetupViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSetupViewModel.h"
#import "Logout_Request.h"

#import "JPUSHService.h"

@implementation ETSetupViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.logoutCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            [MobClick profileSignOff];
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
    
}

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

- (RACSubject *)logoutEndSubject {
    if (!_logoutEndSubject) {
        _logoutEndSubject = [RACSubject subject];
    }
    return _logoutEndSubject;
}

- (RACSubject *)refreshSubject {
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

@end
