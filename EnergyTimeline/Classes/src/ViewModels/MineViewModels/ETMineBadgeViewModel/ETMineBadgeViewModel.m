//
//  ETMineBadgeViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineBadgeViewModel.h"
#import "Mine_User_Badge_List_Request.h"

@implementation ETMineBadgeViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            self.badgeCount = [responseObject[@"Data"][@"MyBadgeNum"] integerValue];
            NSMutableArray *pkArr = [[NSMutableArray alloc] init];
            NSMutableArray *earlyArr = [[NSMutableArray alloc] init];
            NSMutableArray *checkInArr = [[NSMutableArray alloc] init];

            for (NSDictionary *dic in responseObject[@"Data"][@"_PK_Badge"]) {
                ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
                [pkArr addObject:model];
            }
            for (NSDictionary *dic in responseObject[@"Data"][@"_EarlyCheckIn_Badge"]) {
                ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
                [earlyArr addObject:model];
            }
            for (NSDictionary *dic in responseObject[@"Data"][@"_CheckIn_Badge"]) {
                ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
                [checkInArr addObject:model];
            }
            
            self.pkArray = pkArr;
            self.earlyArray = earlyArr;
            self.checkInArray = checkInArr;
            
            self.dataArray = @[self.pkArray, self.earlyArray, self.checkInArray];
        }
        [self.refreshEndSubject sendNext:nil];
    }];
}


- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Mine_User_Badge_List_Request *badgeRequest = [[Mine_User_Badge_List_Request alloc] init];
                [badgeRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    if (request.responseStatusCode == 401) {
                        [MBProgressHUD showMessage:@"请登录"];
                    }
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshDataCommand;
}

- (NSArray *)pkArray {
    if (!_pkArray) {
        _pkArray = [[NSArray alloc] init];
    }
    return _pkArray;
}

- (NSArray *)earlyArray {
    if (!_earlyArray) {
        _earlyArray = [[NSArray alloc] init];
    }
    return _earlyArray;
}

- (NSArray *)checkInArray {
    if (!_checkInArray) {
        _checkInArray = [[NSArray alloc] init];
    }
    return _checkInArray;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

@end
