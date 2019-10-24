//
//  ETReportPKCompletedViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/10/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKCompletedViewModel.h"
#import "ETDailyPKProjectRankListModel.h"
#import "PK_Report_List_Today_UserID_Request.h"


@implementation ETReportPKCompletedViewModel

- (void)et_initialize {
    @weakify(self)
    
    self.userID = 0;
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.pkDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
}

#pragma mark -- lazyLoad --

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                PK_Report_List_Today_UserID_Request *todayRequest = [[PK_Report_List_Today_UserID_Request alloc] initWithUserID:self.userID];
                [todayRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
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

- (RACSubject *)completedSubject {
    if (!_completedSubject) {
        _completedSubject = [RACSubject subject];
    }
    return _completedSubject;
}

- (RACSubject *)reportPostSubject {
    if (!_reportPostSubject) {
        _reportPostSubject = [RACSubject subject];
    }
    return _reportPostSubject;
}

- (NSArray *)pkDataArray {
    if (!_pkDataArray) {
        _pkDataArray = [[NSArray alloc] init];
    }
    return _pkDataArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
