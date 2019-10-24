//
//  ETTrainAudioDownloadViewModel.m
//  能量圈
//
//  Created by 王斌 on 2018/3/27.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainAudioDownloadViewModel.h"
#import "PK_Pro_Train_CommonFileList_Request.h" // 获取公用文件列表
#import "PK_Pro_Train_CommonFile_Get_Request.h" // 获取公用文件下载链接
#import "PK_Pro_Train_FileList_Request.h" // 获取项目训练文件列表
#import "PK_Pro_Train_File_Get_Request.h" // 获取项目训练音频文件下载链接(是否有公用文件)

@implementation ETTrainAudioDownloadViewModel

- (void)et_initialize {
    
    @weakify(self)
    
    [self.commonFileListCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            
            NSArray *commonList = responseObject[@"Data"];
            
            // 缓存路径
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            // 拼接公用文件路径
            NSString *commonPath = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/TrainAudio/common"]];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:commonPath]) {
                NSLog(@"公用文件存在");
                // 浅遍历文件路径内的所有文件,获取包含所有文件名的数组
                NSArray *commonListArr = [fileManager contentsOfDirectoryAtPath:commonPath error:nil];
                NSLog(@"浅遍历:%@ \n", commonListArr);
                
                // 比较数组内容
//                if (commonList.count == commonListArr.count) {
//                    for (NSString *file in commonList) {
//                        if (![commonListArr containsObject:file]) {
//                            self.updateCommonFile = YES;
//                            break;
//                        }
//                    }
//                }
                
                if (commonList.count == commonListArr.count) {
                    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", commonList];
                    NSArray *resultFilteredArray = [commonListArr filteredArrayUsingPredicate:filterPredicate];
                    self.updateCommonFile = resultFilteredArray.count > 0;
                } else {
                    self.updateCommonFile = YES;
                }
                
                NSLog(@"%@", self.updateCommonFile ? @"YES" : @"NO");
            } else {
                NSLog(@"公用文件不存在");
                self.updateCommonFile = YES;
            }
            
            NSLog(@"%@", responseObject);
            
            [self.projectFileListCommand execute:nil];
        }
    }];
    
    [self.projectFileListCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue] == 200) {
            
            NSArray *trainList = responseObject[@"Data"];
            
            // 缓存路径
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            // 拼接训练文件路径
            NSString *trainPath = [cachesPath stringByAppendingString:[NSString stringWithFormat:@"/TrainAudio/%@", self.model.ProjectID]];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:trainPath]) {
                NSLog(@"训练文件存在");
                // 浅遍历文件路径内的所有文件,获取包含所有文件名的数组
                NSArray *trainListArr = [fileManager contentsOfDirectoryAtPath:trainPath error:nil];
                NSLog(@"浅遍历:%@ \n", trainListArr);
                
//                // 比较数组内容
//                if (trainList.count == trainListArr.count) {
//                    for (NSString *file in trainList) {
//                        if (![trainListArr containsObject:file]) {
//                            self.updateTrainFile = YES;
//                            break;
//                        }
//                    }
//                }
                
                if (trainList.count == trainListArr.count) {
                    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", trainList];
                    NSArray *resultFilteredArray = [trainListArr filteredArrayUsingPredicate:filterPredicate];
                    self.updateTrainFile = resultFilteredArray.count > 0;
                } else {
                    self.updateTrainFile = YES;
                }
                
                NSLog(@"%@", self.updateTrainFile ? @"YES" : @"NO");
            } else {
                NSLog(@"训练文件不存在");
                self.updateTrainFile = YES;
            }
            
            NSLog(@"%@", responseObject);
            
            if (self.updateTrainFile) {
                [self.projectFileGetCommand execute:nil];
            } else {
                if (self.updateCommonFile) {
                    [self.commonFileGetCommand execute:nil];
                }
//                } else {
//                    [self.startTrainSubject sendNext:nil];
//                }
            }
            
        }
    }];
    
    [self.commonFileGetCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", responseObject);
            [self.downloadSubject sendNext:responseObject[@"Data"]];
        }
    }];
    
    [self.projectFileGetCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", responseObject);
            [self.downloadSubject sendNext:responseObject[@"Data"]];
        }
    }];
    
}

#pragma mark -- lazyLoad --

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

- (RACSubject *)downloadSubject {
    if (!_downloadSubject) {
        _downloadSubject = [RACSubject subject];
    }
    return _downloadSubject;
}

- (RACSubject *)pauseDownloadSubject {
    if (!_pauseDownloadSubject) {
        _pauseDownloadSubject = [RACSubject subject];
    }
    return _pauseDownloadSubject;
}

- (RACSubject *)startDownloadSubject {
    if (!_startDownloadSubject) {
        _startDownloadSubject = [RACSubject subject];
    }
    return _startDownloadSubject;
}

// 获取公用文件列表
- (RACCommand *)commonFileListCommand {
    if (!_commonFileListCommand) {
        _commonFileListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_CommonFileList_Request *commonFileRequest = [[PK_Pro_Train_CommonFileList_Request alloc] init];
                [commonFileRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _commonFileListCommand;
}

// 获取公用文件下载链接
- (RACCommand *)commonFileGetCommand {
    if (!_commonFileGetCommand) {
        _commonFileGetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_CommonFile_Get_Request *commonFileGetRequest = [[PK_Pro_Train_CommonFile_Get_Request alloc] init];
                [commonFileGetRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _commonFileGetCommand;
}

// 获取项目文件列表
- (RACCommand *)projectFileListCommand {
    if (!_projectFileListCommand) {
        _projectFileListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_FileList_Request *fileListRequest = [[PK_Pro_Train_FileList_Request alloc] initWithProjectID:[self.model.ProjectID integerValue]];
                [fileListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _projectFileListCommand;
}

// 获取项目文件下载链接(包含是否需要公用文件)
- (RACCommand *)projectFileGetCommand {
    if (!_projectFileGetCommand) {
        _projectFileGetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Pro_Train_File_Get_Request *fileGetRequest =[[PK_Pro_Train_File_Get_Request alloc] initWithProjectID:[self.model.ProjectID integerValue] Is_HaveCommon:ETBOOL(self.updateCommonFile)];
                [fileGetRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _projectFileGetCommand;
}

- (void)setModel:(ETPKProjectTrainModel *)model {
    _model = model;
    [self.refreshSubject sendNext:nil];
}

@end
