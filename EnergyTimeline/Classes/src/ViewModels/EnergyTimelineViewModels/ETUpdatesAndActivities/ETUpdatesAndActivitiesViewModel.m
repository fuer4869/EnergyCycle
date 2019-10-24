//
//  ETUpdatesAndActivitiesViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/8/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUpdatesAndActivitiesViewModel.h"
#import "ET_Version_Last_Get_Request.h"
#import "ET_Sys_Notice_List_Request.h"

@implementation ETUpdatesAndActivitiesViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.versionCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"]; // 获取当前应用版本号
            NSString *serverAppVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverAppVersion"]; // 获取存储在应用内的服务器应用版本号
            serverAppVersion = serverAppVersion ? serverAppVersion : appVersion; // 如果应用内没有存储过服务器应用版本号就用当前应用版本号来进行比对
            
            NSString *serverLatestVersion = responseObject[@"Data"][@"ios"]; // 服务器最新版本号

//            [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray array] forKey:@"activityList"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (![serverAppVersion isEqualToString:serverLatestVersion]) { // 服务器最新的版本号和本地存储的版本号做比对查看是否需要做更新提醒
                [[NSUserDefaults standardUserDefaults] setObject:serverLatestVersion forKey:@"serverAppVersion"]; // 存储最新服务器版本
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 版本不同做更新提醒
                self.updateRemind = YES;
                
            } else {
                self.functionRemind = ![[[NSUserDefaults standardUserDefaults] objectForKey:@"appFunctionVersion"] isEqualToString:serverAppVersion]; // 比对本地存储的功能版本号与服务器版本号, 如果不相同那么说明应用更新过确没有提示过新版本功能
                [[NSUserDefaults standardUserDefaults] setObject:serverAppVersion forKey:@"appFunctionVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (self.functionRemind) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray array] forKey:@"activityList"];
                    [[NSUserDefaults standardUserDefaults] synchronize]; // 清空存储的已读活动
                }

            }
            [self.versionSubject sendNext:nil];
        }
    }];
    
    [self.sysDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *activityList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"activityList"] mutableCopy]; // 所有已读活动
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETSysModel *model = [[ETSysModel alloc] initWithDictionary:dic error:nil];
                if (self.updateRemind && [model.NoticeType isEqualToString:@"1"]) {
                    [array addObject:model];
                } else if (self.functionRemind && [model.NoticeType isEqualToString:@"2"]) {
                    [array addObject:model];
                } else if ([model.NoticeType isEqualToString:@"3"] && ![activityList containsObject:model.Sys_NoticeID]) {
                    [array addObject:model];
                    [activityList addObject:model.Sys_NoticeID];
                    [[NSUserDefaults standardUserDefaults] setObject:activityList forKey:@"activityList"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            self.dataArray = array;
        }
        [self.endSubject sendNext:nil];
    }];
    
}

#pragma mark -- lazyLoad -- 

- (RACCommand *)versionCommand {
    if (!_versionCommand) {
        _versionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                ET_Version_Last_Get_Request *versionRequest = [[ET_Version_Last_Get_Request alloc] init];
                [versionRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _versionCommand;
}

- (RACCommand *)sysDataCommand {
    if (!_sysDataCommand) {
        _sysDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                ET_Sys_Notice_List_Request *sysRequest = [[ET_Sys_Notice_List_Request alloc] init];
                [sysRequest  startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _sysDataCommand;
}

- (RACSubject *)versionSubject {
    if (!_versionSubject) {
        _versionSubject = [RACSubject subject];
    }
    return _versionSubject;
}

- (RACSubject *)endSubject {
    if (!_endSubject) {
        _endSubject = [RACSubject subject];
    }
    return _endSubject;
}

- (RACSubject *)activePageSubject {
    if (!_activePageSubject) {
        _activePageSubject = [RACSubject subject];
    }
    return _activePageSubject;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (RACSubject *)functionSubject {
    if (!_functionSubject) {
        _functionSubject = [RACSubject subject];
    }
    return _functionSubject;
}

- (RACSubject *)nothingSubject {
    if (!_nothingSubject) {
        _nothingSubject = [RACSubject subject];
    }
    return _nothingSubject;
}

@end
