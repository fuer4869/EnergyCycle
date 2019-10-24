//
//  ETPKProjectPageViewModel.m
//  能量圈
//
//  Created by 王斌 on 2018/1/10.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectPageViewModel.h"
#import "ETPKProjectViewModel.h"
#import "ETDailyPKProjectRankListModel.h"
#import "ETPKProjectTypeModel.h" // 项目分类模型
#import "PK_Project_List_Requset.h" // 项目列表
#import "PK_ProjectType_List_Request.h" // 项目分类列表
#import "User_FirstEnter_Get_Request.h"
#import "User_FirstEnter_Upd_Request.h"
#import "File_Upload_Request.h"
#import "User_PKCoverImg_Upd_Request.h"
#import "PK_ReportProject_Del_Request.h"

@implementation ETPKProjectPageViewModel

- (void)et_initialize {
    @weakify(self)
    
    [self.firstEnterDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.firstEnterModel = [[ETFirstEnterModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.firstEnterEndSubject sendNext:nil];
        }
    }];
    
    [self.uploadPKCoverImgCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue]) {
            NSLog(@"图片更换成功");
            [self.refreshSubject sendNext:self.titleArray[self.currentIndex]];
        }
    }];
    
    [self.projectDelCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue]) {
            [self.backSubject sendNext:nil];
        }
    }];
}

#pragma mark -- lazyLoad --

- (RACCommand *)projectListCommand {
    if (!_projectListCommand) {
        @weakify(self)
        _projectListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                PK_Project_List_Requset *projectListRequest = [[PK_Project_List_Requset alloc] init];
                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200) {
                        NSMutableArray *array = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in request.responseObject[@"Data"]) {
                            ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                            [array addObject:model];
                        }
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
    return _projectListCommand;
}

- (RACCommand *)projectTypeListCommand {
    if (!_projectTypeListCommand) {
        @weakify(self)
        _projectTypeListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                PK_ProjectType_List_Request *projectTypeListRequest = [[PK_ProjectType_List_Request alloc] initWithSearchKey:@"" Sort:ETBOOL(YES)];
                [projectTypeListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200 && [request.responseObject[@"Data"] count]) {
                        NSMutableArray *typeArray = [[NSMutableArray alloc] init];
                        NSMutableArray *typeDataArray = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in request.responseObject[@"Data"]) {
                            ETPKProjectTypeModel *typeModel = [[ETPKProjectTypeModel alloc] initWithDictionary:dic error:nil];
                            NSMutableArray *projectArray = [[NSMutableArray alloc] init];
                            for (NSDictionary *projectDic in dic[@"_Project_List"]) {
                                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:projectDic error:nil];
                                [projectArray addObject:model];
                            }
                            [typeArray addObject:typeModel];
                            [typeDataArray addObject:projectArray];
                        }
                        self.projectTypeArray = typeArray;
                        self.projectTypeDataArray = typeDataArray;
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
    return _projectTypeListCommand;
}

- (RACCommand *)firstEnterDataCommand {
    if (!_firstEnterDataCommand) {
        _firstEnterDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_FirstEnter_Get_Request *firstEnterGetRequest = [[User_FirstEnter_Get_Request alloc] init];
                [firstEnterGetRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _firstEnterDataCommand;
}

- (RACCommand *)firstEnterUpdCommand {
    if (!_firstEnterUpdCommand) {
        _firstEnterUpdCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *str) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                User_FirstEnter_Upd_Request *firstEnterUpdRequest = [[User_FirstEnter_Upd_Request alloc] initWithStr:str];
                [firstEnterUpdRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _firstEnterUpdCommand;
}

- (RACCommand *)uploadFileCommand {
    if (!_uploadFileCommand) {
        _uploadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *imageData) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [File_Upload_Request uploadWithImageData:imageData success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                    [MBProgressHUD showMessage:@"图片上传失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _uploadFileCommand;
}

- (RACCommand *)uploadPKCoverImgCommand {
    if (!_uploadPKCoverImgCommand) {
        @weakify(self)
        _uploadPKCoverImgCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSData *imageData) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                [[self.uploadFileCommand execute:imageData] subscribeNext:^(id responseObject) {
                    if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
                        User_PKCoverImg_Upd_Request *pkCoverImgRequest = [[User_PKCoverImg_Upd_Request alloc] initWithFileID:[responseObject[@"Data"][0] integerValue]];
                        [pkCoverImgRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                            [subscriber sendNext:request.responseObject];
                            [subscriber sendCompleted];
                        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                            [MBProgressHUD showMessage:@"图片上传失败"];
                            [subscriber sendCompleted];
                        }];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _uploadPKCoverImgCommand;
}

- (RACCommand *)projectDelCommand {
    if (!_projectDelCommand) {
        @weakify(self)
        _projectDelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                ETPKProjectViewModel *viewModel = self.dataArray[self.currentIndex];
                PK_ReportProject_Del_Request *projectDelRequest = [[PK_ReportProject_Del_Request alloc] initWithProjectID:[viewModel.model.ProjectID integerValue]];
                [projectDelRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _projectDelCommand;
}

//- (NSArray *)dataArray {
//    if (!_dataArray) {
//        _dataArray = [[NSArray alloc] init];
//    }
//    return _dataArray;
//}

- (void)setDataArray:(NSArray *)dataArray {
    if (!dataArray) {
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    for (ETDailyPKProjectRankListModel *model in dataArray) {
        ETPKProjectViewModel *viewModel = [[ETPKProjectViewModel alloc] init];
        viewModel.model = model;
        viewModel.setupPKCoverSubject = self.setupPKCoverSubject;
        viewModel.refreshSubject = self.refreshSubject;
        [titles addObject:model.ProjectName];
        [array addObject:viewModel];
    }
    
    _titleArray = titles;
    _dataArray = array;
    
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSArray alloc] init];
    }
    return _titleArray;
}

- (NSArray *)projectTypeArray {
    if (!_projectTypeArray) {
        _projectTypeArray = [[NSArray alloc] init];
    }
    return _projectTypeArray;
}

- (NSArray *)projectTypeDataArray {
    if (!_projectTypeDataArray) {
        _projectTypeDataArray = [[NSArray alloc] init];
    }
    return _projectTypeDataArray;
}

- (NSArray *)coverImgArray {
    if (!_coverImgArray) {
        _coverImgArray = [[NSArray alloc] init];
    }
    return _coverImgArray;
}

- (RACSubject *)firstEnterEndSubject {
    if (!_firstEnterEndSubject) {
        _firstEnterEndSubject = [RACSubject subject];
    }
    return _firstEnterEndSubject;
}

- (RACSubject *)setupPKCoverSubject {
    if (!_setupPKCoverSubject) {
        _setupPKCoverSubject = [RACSubject subject];
    }
    return _setupPKCoverSubject;
}

- (RACSubject *)refreshSubject {
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}

- (RACSubject *)backSubject {
    if (!_backSubject) {
        _backSubject = [RACSubject subject];
    }
    return _backSubject;
}

- (RACSubject *)projectListCellClickSubject {
    if (!_projectListCellClickSubject) {
        _projectListCellClickSubject = [RACSubject subject];
    }
    return _projectListCellClickSubject;
}

- (RACSubject *)removeProjectListViewSubject {
    if (!_removeProjectListViewSubject) {
        _removeProjectListViewSubject = [RACSubject subject];
    }
    return _removeProjectListViewSubject;
}

@end
