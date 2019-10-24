//
//  ETSearchProjectViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSearchProjectViewModel.h"
#import "PK_Project_List_NotHaveWalk_Request.h"
#import "PK_ProjectType_List_Request.h"
#import "ETPKProjectTypeModel.h"
#import "ETPKProjectModel.h"

@implementation ETSearchProjectViewModel

- (void)et_initialize {
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.searchDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.isSearch = YES;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETPKProjectModel *model = [[ETPKProjectModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.searchDataArray = array;
        }
        [self.searchEndSubject sendNext:nil];
    }];
}

#pragma mark -- lazyLoad --

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
//                PK_Project_List_NotHaveWalk_Request *projectListRequest = [[PK_Project_List_NotHaveWalk_Request alloc] init];
//                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [subscriber sendNext:request.responseObject];
//                    [subscriber sendCompleted];
//                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                    NSLog(@"%@", request.responseObject);
//                    [subscriber sendCompleted];
//                }];
//                return nil;
                PK_ProjectType_List_Request *projectListRequest = [[PK_ProjectType_List_Request alloc] init];
                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200 && [request.responseObject[@"Data"] count]) {
                        self.isSearch = NO;
                        NSMutableArray *titles = [[NSMutableArray alloc] init];
                        NSMutableArray *typeArray = [[NSMutableArray alloc] init];
                        NSMutableArray *array = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in request.responseObject[@"Data"]) {
                            //                if ([dic[@"ProjectTypeID"] integerValue] < 1) {
                            //                    continue;
                            //                }
                            ETPKProjectTypeModel *typeModel = [[ETPKProjectTypeModel alloc] initWithDictionary:dic error:nil];
                            //                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
                            //                [dataDic setObject:dic[@"ProjectTypeID"] forKey:@"ProjectTypeID"];
                            //                [dataDic setObject:dic[@"ProjectTypeName"] forKey:@"ProjectTypeName"];
                            [titles addObject:dic[@"ProjectTypeName"]];
                            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
                            for (NSDictionary *projectDic in dic[@"_Project_List"]) {
                                ETPKProjectModel *model = [[ETPKProjectModel alloc] initWithDictionary:projectDic error:nil];
                                [projectArray addObject:model];
                            }
                            //                [dataDic setObject:projectArray forKey:@"ProjectList"];
                            [typeArray addObject:typeModel];
                            [array addObject:projectArray];
                            //                [array addObject:dataDic];
                        }
                        self.titleArray = titles;
                        self.projectTypeArray = typeArray;
                        self.dataArray = array;
                    }
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

- (RACCommand *)searchDataCommand {
    if (!_searchDataCommand) {
        _searchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                PK_Project_List_NotHaveWalk_Request *projectListRequest = [[PK_Project_List_NotHaveWalk_Request alloc] initWithSearchKey:self.searchKey];
//                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
//                    [subscriber sendNext:request.responseObject];
//                    [subscriber sendCompleted];
//                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                    NSLog(@"%@", request.responseObject);
//                    [subscriber sendCompleted];
//                }];
//                return nil;
                PK_ProjectType_List_Request *projectListRequest = [[PK_ProjectType_List_Request alloc] initWithSearchKey:self.searchKey];
                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _searchDataCommand;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)searchEndSubject {
    if (!_searchEndSubject) {
        _searchEndSubject = [RACSubject subject];
    }
    return _searchEndSubject;
}

- (RACSubject *)selectProjectSubject {
    if (!_selectProjectSubject) {
        _selectProjectSubject = [RACSubject subject];
    }
    return _selectProjectSubject;
}

- (RACSubject *)promiseSetProjectSubject {
    if (!_promiseSetProjectSubject) {
        _promiseSetProjectSubject = [RACSubject subject];
    }
    return _promiseSetProjectSubject;
}

- (RACSubject *)newProejctSubject {
    if (!_newProejctSubject) {
        _newProejctSubject = [RACSubject subject];
    }
    return _newProejctSubject;
}

- (RACSubject *)reportPKSubject {
    if (!_reportPKSubject) {
        _reportPKSubject = [RACSubject subject];
    }
    return _reportPKSubject;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSArray alloc] init];
    }
    return _titleArray;
}

- (NSArray *)typeImageArray {
    if (!_typeImageArray) {
        _typeImageArray = [[NSArray alloc] init];
    }
    return _typeImageArray;
}

- (NSArray *)projectTypeArray {
    if (!_projectTypeArray) {
        _projectTypeArray = [[NSArray alloc] init];
    }
    return _projectTypeArray;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSArray *)searchDataArray {
    if (!_searchDataArray) {
        _searchDataArray = [[NSArray alloc] init];
    }
    return _searchDataArray;
}

@end
