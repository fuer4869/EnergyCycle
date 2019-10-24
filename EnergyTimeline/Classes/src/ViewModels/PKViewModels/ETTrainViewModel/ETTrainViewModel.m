//
//  ETTrainViewModel.m
//  能量圈
//
//  Created by 王斌 on 2018/3/19.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainViewModel.h"
#import "ETTrainAudioManager.h"
#import "PK_Pro_Train_Get_Request.h"
#import "PK_Pro_Train_Group_Upd_Request.h"
#import "PK_Pro_Train_End_Request.h"
#import "PK_Pro_Train_Finish_Request.h"

@implementation ETTrainViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.trainGetCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", responseObject);
            self.audioPlayList = responseObject[@"Data"][@"Audio_List"];
            ETPKProjectTrainModel *model = [[ETPKProjectTrainModel alloc] initWithDictionary:responseObject[@"Data"][@"Pro_Train"] error:nil];
            self.model = model;
        }
        [self.refreshSubject sendNext:nil];
    }];
    
    [self.trainUpdateCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", responseObject);
            if ([self.model.CurrGroupNo isEqualToString:self.model.GroupCount]) {
                [self.trainFinishSubject sendNext:nil];
            } else {
                [self.trainGetCommand execute:nil];
            }
        }
    }];
    
//    [self.trainEndCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
//        @strongify(self)
//        if ([responseObject[@"Status"] integerValue] == 200) {
//            NSLog(@"%@", responseObject);
//            [self.trainEndSubject sendNext:nil];
//        }
//    }];

//    [self.trainFinishCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
//        @strongify(self)
//        if ([responseObject[@"Status"] integerValue] == 200) {
//            NSLog(@"%@", responseObject);
//            [self.trainFinishSubject sendNext:nil];
//        }
//    }];
    
}

#pragma mark -- lazyLoad --

- (RACCommand *)trainGetCommand {
    if (!_trainGetCommand) {
        _trainGetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_Get_Request *trainRequest = [[PK_Pro_Train_Get_Request alloc] initWithTrainID:self.trainID];
                [trainRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _trainGetCommand;
}

- (RACCommand *)trainUpdateCommand {
    if (!_trainUpdateCommand) {
        _trainUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_Group_Upd_Request *trainUpdRequest = [[PK_Pro_Train_Group_Upd_Request alloc] initWithTrainID:self.trainID GroupNo:[self.model.CurrGroupNo integerValue] Duration:[[ETTrainAudioManager sharedInstance] totalTrainPlayTime]];
                [trainUpdRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _trainUpdateCommand;
}

- (RACCommand *)trainEndCommand {
    if (!_trainEndCommand) {
        _trainEndCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_End_Request *trainEndRequest = [[PK_Pro_Train_End_Request alloc] initWithTrainID:self.trainID];
                [trainEndRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _trainEndCommand;
}

- (RACCommand *)trainFinishCommand {
    if (!_trainFinishCommand) {
        _trainFinishCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_Finish_Request *trainFinishRequest = [[PK_Pro_Train_Finish_Request alloc] initWithTrainID:self.trainID];
                [trainFinishRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _trainFinishCommand;
}

- (RACSubject *)backSubject {
    if (!_backSubject) {
        _backSubject = [RACSubject subject];
    }
    return _backSubject;
}

- (RACSubject *)refreshSubject {
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}

- (RACSubject *)startTrainSubject {
    if (!_startTrainSubject) {
        _startTrainSubject = [RACSubject subject];
    }
    return _startTrainSubject;
}

- (RACSubject *)continueTrainSubject {
    if (!_continueTrainSubject) {
        _continueTrainSubject = [RACSubject subject];
    }
    return _continueTrainSubject;
}

- (RACSubject *)restStartSubject {
    if (!_restStartSubject) {
        _restStartSubject = [RACSubject subject];
    }
    return _restStartSubject;
}

- (RACSubject *)restEndSubject {
    if (!_restEndSubject) {
        _restEndSubject = [RACSubject subject];
    }
    return _restEndSubject;
}

- (RACSubject *)setupSubject {
    if (!_setupSubject) {
        _setupSubject = [RACSubject subject];
    }
    return _setupSubject;
}

- (RACSubject *)trainEndSubject {
    if (!_trainEndSubject) {
        _trainEndSubject = [RACSubject subject];
    }
    return _trainEndSubject;
}

- (RACSubject *)trainFinishSubject {
    if (!_trainFinishSubject) {
        _trainFinishSubject = [RACSubject subject];
    }
    return _trainFinishSubject;
}

- (RACSubject *)trainFinishEndSubject {
    if (!_trainFinishEndSubject) {
        _trainFinishEndSubject = [RACSubject subject];
    }
    return _trainFinishEndSubject;
}

- (RACSubject *)closeSubject {
    if (!_closeSubject) {
        _closeSubject = [RACSubject subject];
    }
    return _closeSubject;
}

@end
