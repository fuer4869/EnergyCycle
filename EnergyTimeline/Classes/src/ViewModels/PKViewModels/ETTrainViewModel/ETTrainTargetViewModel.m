//
//  ETTrainTargetViewModel.m
//  能量圈
//
//  Created by 王斌 on 2018/3/26.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainTargetViewModel.h"
#import "PK_Project_Get_Request.h"
#import "PK_Pro_Train_Add_Request.h"

#import "ETTrainAudioManager.h"

@implementation ETTrainTargetViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.projectGetCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            ETPKProjectModel *model = [[ETPKProjectModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            self.model = model;
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 1; i <= ([self.model.Trainlimit integerValue] / [self.model.GroupNum integerValue]); i ++) {
                [array addObject:[NSString stringWithFormat:@"%ld", (long)[self.model.GroupNum integerValue] * i]];
            }
            self.trainArray = array;
            self.trainTarget = array[0];
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.trainAddCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.trainID = [responseObject[@"Data"] integerValue];
        }
        [self.nextSubject sendNext:nil];
    }];
    
}

#pragma mark -- lazyLoad --

- (RACCommand *)projectGetCommand {
    if (!_projectGetCommand) {
        _projectGetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Project_Get_Request *projectRequest = [[PK_Project_Get_Request alloc] initWithProjectID:self.projectID];
                [projectRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _projectGetCommand;
}

- (RACCommand *)trainAddCommand {
    if (!_trainAddCommand) {
        _trainAddCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSInteger soundType = [self.coach isEqualToString:@"海哥"] ? 1 : ([self.coach isEqualToString:@"熊威"] ? 2 : 3);
                
                NSString *bgmFileName = @"";
                if ([self.bgm isEqualToString:@"舒缓"]) {
                    bgmFileName = [[ETTrainAudioManager sharedInstance] bgmArr][ETTrainBGMFirst];
                } else if ([self.bgm isEqualToString:@"轻松"]) {
                    bgmFileName = [[ETTrainAudioManager sharedInstance] bgmArr][ETTrainBGMSecond];
                } else if ([self.bgm isEqualToString:@"激情"]) {
                    bgmFileName = [[ETTrainAudioManager sharedInstance] bgmArr][ETTrainBGMThird];
                } else if ([self.bgm isEqualToString:@"紧张"]) {
                    bgmFileName = [[ETTrainAudioManager sharedInstance] bgmArr][ETTrainBGMFourth];
                }
                
                PK_Pro_Train_Add_Request *targetRequest = [[PK_Pro_Train_Add_Request alloc] initWithProjectID:self.projectID TargetNum:[self.trainTarget integerValue] SoundType:soundType BGMFileName:bgmFileName];
                [targetRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _trainAddCommand;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)backSubject {
    if (!_backSubject) {
        _backSubject = [RACSubject subject];
    }
    return _backSubject;
}

- (RACSubject *)nextSubject {
    if (!_nextSubject) {
        _nextSubject = [RACSubject subject];
    }
    return _nextSubject;
}

- (NSArray *)trainArray {
    if (!_trainArray) {
        _trainArray = [NSArray array];
    }
    return _trainArray;
}

@end
