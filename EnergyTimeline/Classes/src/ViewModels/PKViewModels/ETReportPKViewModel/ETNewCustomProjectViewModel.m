//
//  ETNewCustomProjectViewModel.m
//  能量圈
//
//  Created by 王斌 on 2018/2/1.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETNewCustomProjectViewModel.h"
#import "PK_Project_Add_Request.h"

@implementation ETNewCustomProjectViewModel

- (void)et_initialize {
    @weakify(self)
    
    self.customStatus = ETNewCustomProjectStatusName;
    
    self.unitArray = @[@"秒", @"分钟", @"小时", @"天",
                       @"米", @"公里", @"次",
                       @"个", @"组", @"页"];
    
    self.unit = self.unitArray[0];
    
    [self.newProjectCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", responseObject);
            [self.completedSubject sendNext:nil];
            [self.removeSubject sendNext:nil];
        }
    }];
    
}

#pragma mark -- lazyLoad --

- (RACCommand *)newProjectCommand {
    if (!_newProjectCommand) {
        _newProjectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Project_Add_Request *addRequest = [[PK_Project_Add_Request alloc] initWithProjectName:self.projectName projectUnit:self.unit];
                [addRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _newProjectCommand;
}

- (RACSubject *)setNameSubject {
    if (!_setNameSubject) {
        _setNameSubject = [RACSubject subject];
    }
    return _setNameSubject;
}

- (RACSubject *)stautsChangeSubject {
    if (!_stautsChangeSubject) {
        _stautsChangeSubject = [RACSubject subject];
    }
    return _stautsChangeSubject;
}

- (RACSubject *)removeSubject {
    if (!_removeSubject) {
        _removeSubject = [RACSubject subject];
    }
    return _removeSubject;
}

- (RACSubject *)completedSubject {
    if (!_completedSubject) {
        _completedSubject = [RACSubject subject];
    }
    return _completedSubject;
}

- (NSArray *)unitArray {
    if (!_unitArray) {
        _unitArray = [[NSArray alloc] init];
    }
    return _unitArray;
}

@end
