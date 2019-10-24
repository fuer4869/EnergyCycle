//
//  ETRadioViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/6.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRadioViewModel.h"
#import "ETRadioManager.h"
#import "Find_Radio_List_Request.h"


#import "AppDelegate.h"
#import "RadioClockModel.h"

@interface ETRadioViewModel () {
    AppDelegate *delegate;
    RadioClockModel *clockModel;
}

@end

@implementation ETRadioViewModel

- (void)et_initialize {
//    [ETRadioLocalModel clearTable];
    delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.translateRadioList) {
        delegate.translateRadioList = NO;
        clockModel = [[RadioClockModel findAll] firstObject];
    }
    NSArray *arr = [ETRadioLocalModel findAll];
    self.localModel = [arr firstObject];
    @weakify(self)
    [self.radioDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETRadioModel *model = [[ETRadioModel alloc] initWithDictionary:dic error:nil];
                if ([clockModel.channelName isEqualToString:model.RadioName]) {
                    self.localModel.radioID = model.RadioID;
                    [[ETRadioManager sharedInstance] playUrlWithString:model.RadioUrl];
                    [[ETRadioManager sharedInstance] clockModel:clockModel];
                    clockModel = nil;
                }
                if (!self.localModel || [model.RadioID isEqualToString:self.localModel.radioID]) {
                    NSLog(@"11");
                    if (!self.localModel) {
                        self.localModel = [[ETRadioLocalModel alloc] init];
                    }
                    [self updateLocalModel:model];
                }
                [array addObject:model];
            }
            self.currentIndex = [array indexOfObject:self.radioModel];
            self.radioArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [[self.replacePlaySubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *index) {
        if ([index integerValue] != self.currentIndex) {
            self.currentIndex = [index integerValue];
            [self updateLocalModel:self.radioArray[[index integerValue]]];
            [[ETRadioManager sharedInstance] playUrlWithString:[self.radioArray[[index integerValue]] RadioUrl]];
            [self.replaceEndSubject sendNext:nil];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"RadioTimerPlay" object:nil] subscribeNext:^(NSNotification *notification) {
        @strongify(self)
        if (delegate.translateRadioList) {
            delegate.translateRadioList = NO;
            clockModel = [[RadioClockModel findAll] firstObject];
        }
        for (ETRadioModel *model in self.radioArray) {
            if ([clockModel.channelName isEqualToString:model.RadioName]) {
                [[ETRadioManager sharedInstance] playUrlWithString:model.RadioUrl];
                [[ETRadioManager sharedInstance] clockModel:clockModel];
                clockModel = nil;
                [self.refreshEndSubject sendNext:nil];
                break;
            }
        }
    }];
    
}

- (void)updateLocalModel:(ETRadioModel *)model {
    self.localModel.radioID = model.RadioID;
    self.localModel.radioName = model.RadioName;
    self.localModel.radioUrl = model.RadioUrl;
    self.localModel.radioBg = model.Radio_Bg;
    self.localModel.radioBgDim = model.Radio_Bg_Dim;
    self.localModel.radioIcon = model.Radio_Icon;
    [self.localModel saveOrUpdate];
    self.radioModel = model;
}

#pragma mark -- lazyLoad --

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)dismissSubject {
    if (!_dismissSubject) {
        _dismissSubject = [RACSubject subject];
    }
    return _dismissSubject;
}

- (RACCommand *)radioDataCommand {
    if (!_radioDataCommand) {
        _radioDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Find_Radio_List_Request *radioRequest = [[Find_Radio_List_Request alloc] initWithPageIndex:1 PageSize:100];
                [radioRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _radioDataCommand;
}

- (NSArray *)radioArray {
    if (!_radioArray) {
        _radioArray = [[NSArray alloc] init];
    }
    return _radioArray;
}

- (RACSubject *)replacePlaySubject {
    if (!_replacePlaySubject) {
        _replacePlaySubject = [RACSubject subject];
    }
    return _replacePlaySubject;
}

- (RACSubject *)replaceEndSubject {
    if (!_replaceEndSubject) {
        _replaceEndSubject = [RACSubject subject];
    }
    return _replaceEndSubject;
}

- (RACSubject *)radioVCSubject {
    if (!_radioVCSubject) {
        _radioVCSubject = [RACSubject subject];
    }
    return _radioVCSubject;
}

- (RACSubject *)radioPlayVCSubject {
    if (!_radioPlayVCSubject) {
        _radioPlayVCSubject = [RACSubject subject];
    }
    return _radioPlayVCSubject;
}

- (RACSubject *)radioDurationTimeVCSubject {
    if (!_radioDurationTimeVCSubject) {
        _radioDurationTimeVCSubject = [RACSubject subject];
    }
    return _radioDurationTimeVCSubject;
}

@end
