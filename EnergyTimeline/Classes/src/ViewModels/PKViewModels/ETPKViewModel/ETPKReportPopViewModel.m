//
//  ETPKReportPopViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKReportPopViewModel.h"
#import "PK_v4_Report_Add_Request.h"

@implementation ETPKReportPopViewModel

- (void)et_initialize {
    @weakify(self)
    [self.reportCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", responseObject);
            [self.reportCompletedSubject sendNext:responseObject];
        }
    }];
}

- (RACCommand *)reportCommand {
    if (!_reportCommand) {
        @weakify(self)
        _reportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [MBProgressHUD showHUDAddedTo:ETWindow animated:YES];
//                PK_v3_Report_Add_Request *reportRequest = [[PK_v3_Report_Add_Request alloc] initWithReport_Items:self.projectNumArray Is_Sync:ETBOOL(NO) FileIDs:@""];;
                PK_v4_Report_Add_Request *reportRequest = [[PK_v4_Report_Add_Request alloc] initWithReport_Items:self.projectNumArray PostContent:@"" Is_Sync:ETBOOL(NO) FileIDs:@""];
                [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD hideHUDForView:ETWindow animated:YES];
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD hideHUDForView:ETWindow animated:YES];
                    [MBProgressHUD showMessage:@"发布失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _reportCommand;
}

- (RACSubject *)textFieldSubject {
    if (!_textFieldSubject) {
        _textFieldSubject = [RACSubject subject];
    }
    return _textFieldSubject;
}

- (RACSubject *)reportCompletedSubject {
    if (!_reportCompletedSubject) {
        _reportCompletedSubject = [RACSubject subject];
    }
    return _reportCompletedSubject;
}

- (RACSubject *)projectAlarmSubject {
    if (!_projectAlarmSubject) {
        _projectAlarmSubject = [RACSubject subject];
    }
    return _projectAlarmSubject;
}

- (NSMutableArray *)projectNumArray {
    if (!_projectNumArray) {
        _projectNumArray = [[NSMutableArray alloc] init];
    }
    return _projectNumArray;
}

- (ETDailyPKProjectRankListModel *)model {
    if (!_model) {
        _model = [[ETDailyPKProjectRankListModel alloc] init];
    }
    return _model;
}

@end
