//
//  ETProjectViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/8/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectViewModel.h"
//#import "PK_Project_List_Requset.h"
#import "PK_Project_List_NotHaveWalk_Request.h"

#import "ETPKProjectModel.h"

@implementation ETProjectViewModel

- (void)et_initialize {
    
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETPKProjectModel *model = [[ETPKProjectModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.dataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
}

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Project_List_NotHaveWalk_Request *projectListRequest = [[PK_Project_List_NotHaveWalk_Request alloc] init];
                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    NSLog(@"%@", request.responseObject);
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshDataCommand;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)selectProjectSubject {
    if (!_selectProjectSubject) {
        _selectProjectSubject = [RACSubject subject];
    }
    return _selectProjectSubject;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

@end
