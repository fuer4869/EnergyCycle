//
//  ETReportPKPoolViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKPoolViewModel.h"
#import "ETFileModel.h"
#import "ETDailyPKProjectRankListModel.h"
#import "PK_Report_List_Today_UserID_Request.h"
#import "PK_Today_Report_Img_List_Request.h"
#import "File_Upload_Request.h"
#import "PK_Report_Post_Add.h"

/** 提醒 */
#import "User_FirstEnter_Get_Request.h"
#import "User_FirstEnter_Upd_Request.h"

/** 分享title */
#import "PK_Project_RankingNum_Get_Request.h"

#import "NSString+Regex.h"
/** 图片压缩 */
#import "UIImage+Compression.h"

#import "ETRadioManager.h"

@implementation ETReportPKPoolViewModel

- (void)et_initialize {
    @weakify(self)
    
    self.userID = 0;
    
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableString *content = [[NSMutableString alloc] initWithString:@"今天我已完成: "];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETDailyPKProjectRankListModel *model = [[ETDailyPKProjectRankListModel alloc] initWithDictionary:dic error:nil];
                [content appendString:[NSString stringWithFormat:@"%@%@%@,", model.ProjectName, model.ReportNum, model.ProjectUnit]];
                [array addObject:model];
            }
            self.postContent = content;
            self.pkDataArray = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.refreshImgDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *pathArray = [[NSMutableArray alloc] init];
//            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            NSMutableArray *idArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                ETFileModel *model = [[ETFileModel alloc] initWithDictionary:dic error:nil];
                [pathArray addObject:model.FilePath];
                [idArray addObject:model.FileID];
            }

            self.selectImgPathArray = pathArray;
            self.imageIDArray = idArray;
            [self.todayImageIDArray removeAllObjects];
            [self.todayImageIDArray addObjectsFromArray:idArray];
        }
        [self.refreshImageDataEndSubject sendNext:nil];
    }];
    
    [self.reportCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        PK_Report_Post_Add *reportRequest = [[PK_Report_Post_Add alloc] initWithPostContent:self.postContent FileIDs:self.fileIDString];
        [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:ETWindow animated:YES];
//            [[ETRadioManager sharedInstance] playAudioType:ETAudioTypeReportPKPool];
            if ([request.responseObject[@"Status"] integerValue] == 200) {
                if (self.fileIDArray.count) {
                    [self.firstEnterUpdCommand execute:@"Is_FirstPool_Pic"];
                }
                [self.dismissSubject sendNext:request.responseObject];
//                [MBProgressHUD showMessage:@"上传成功"];
            }
        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:ETWindow animated:YES];
            [MBProgressHUD showMessage:@"发布失败"];
        }];
    }];
    
    [self.firstEnterDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            self.firstEnterModel = [[ETFirstEnterModel alloc] initWithDictionary:responseObject[@"Data"] error:nil];
            [self.firstEnterEndSubject sendNext:nil];
        }
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

- (RACCommand *)refreshImgDataCommand {
    if (!_refreshImgDataCommand) {
//        @weakify(self)
        _refreshImgDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                @strongify(self)
                PK_Today_Report_Img_List_Request *imgListRequest = [[PK_Today_Report_Img_List_Request alloc] init];
                [imgListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshImgDataCommand;
}

- (RACCommand *)uploadFileCommand {
    if (!_uploadFileCommand) {
        _uploadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableArray *imageArray = [NSMutableArray array]; // 存储本地图片
                NSMutableArray *imageIndexArray = [NSMutableArray array]; // 存储本地图片在所有图片中的位置
                [self.fileIDArray setArray:self.imageIDArray];
                BOOL fileUpload = NO;
                for (NSInteger i = 0; i < self.imageIDArray.count; i ++) {
                    if ([self.imageIDArray[i] isVaildDigtal]) {
                        NSLog(@"%@-----yes", self.imageIDArray[i]);
                    } else {
                        NSLog(@"%@-----no", self.imageIDArray[i]);
                    }
                    if (![self.imageIDArray[i] isVaildDigtal]) {
                        fileUpload = YES;
                        UIImage *resultImage = [UIImage compressImage:self.selectImgArray[i] toKilobyte:1024];
                        NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.5);
                        [imageArray addObject:imageData];
                        [imageIndexArray addObject:[NSNumber numberWithInteger:i]];
                    }
                }
                if (fileUpload) {
                    [File_Upload_Request uploadWithImageArr:imageArray success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        NSMutableArray *fileIDArr = responseObject[@"Data"];
                        for (NSInteger i = 0; i < imageArray.count; i ++) {
                            NSNumber *indexNum = imageIndexArray[i];
                            NSInteger index = indexNum.integerValue;
                            [self.fileIDArray setObject:fileIDArr[i] atIndexedSubscript:index];
                        }
                        for (NSInteger i = 0; i < self.imageIDArray.count; i ++) {
                            [self.fileIDString appendString:[NSString stringWithFormat:@"%@,", self.fileIDArray[i]]];
                        }
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                        [MBProgressHUD showMessage:@"图片上传失败"];
                        [subscriber sendCompleted];
                    }];
                } else {
                    for (NSInteger i = 0; i < self.imageIDArray.count; i ++) {
                        [self.fileIDString appendString:[NSString stringWithFormat:@"%@,", self.fileIDArray[i]]];
                    }
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }
                return nil;
            }];
        }];
    }
    return _uploadFileCommand;
}

- (RACCommand *)reportCommand {
    if (!_reportCommand) {
        @weakify(self)
        _reportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                if (self.imageIDArray.count) {
                    [MBProgressHUD showHUDAddedTo:ETWindow animated:YES];
                    @strongify(self)
                    [[self.uploadFileCommand execute:nil] subscribeNext:^(id x) {
                        @strongify(self)
                        if (self.fileIDArray.count == self.imageIDArray.count) {
                            [subscriber sendNext:nil];
                            [subscriber sendCompleted];
                        }
                    }];
                } else {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }
                return nil;
            }];
        }];
    }
    return _reportCommand;
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

- (RACCommand *)rankingNumCommand {
    if (!_rankingNumCommand) {
        _rankingNumCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *str) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Project_RankingNum_Get_Request *rankingNumRequest = [[PK_Project_RankingNum_Get_Request alloc] init];
                [rankingNumRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _rankingNumCommand;
}

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)refreshImageDataEndSubject {
    if (!_refreshImageDataEndSubject) {
        _refreshImageDataEndSubject = [RACSubject subject];
    }
    return _refreshImageDataEndSubject;
}

- (RACSubject *)pickerSubject {
    if (!_pickerSubject) {
        _pickerSubject = [RACSubject subject];
    }
    return _pickerSubject;
}

- (RACSubject *)removePictureSubject {
    if (!_removePictureSubject) {
        _removePictureSubject = [RACSubject subject];
    }
    return _removePictureSubject;
}

- (RACSubject *)dismissSubject {
    if (!_dismissSubject) {
        _dismissSubject = [RACSubject subject];
    }
    return _dismissSubject;
}

- (RACSubject *)firstEnterEndSubject {
    if (!_firstEnterEndSubject) {
        _firstEnterEndSubject = [RACSubject subject];
    }
    return _firstEnterEndSubject;
}

- (NSArray *)pkDataArray {
    if (!_pkDataArray) {
        _pkDataArray = [[NSArray alloc] init];
    }
    return _pkDataArray;
}

- (NSMutableArray *)selectImgPathArray {
    if (!_selectImgPathArray) {
        _selectImgPathArray = [[NSMutableArray alloc] init];
    }
    return _selectImgPathArray;
}

- (NSMutableArray *)selectImgArray {
    if (!_selectImgArray) {
        _selectImgArray = [[NSMutableArray alloc] init];
    }
    return _selectImgArray;
}

- (NSMutableArray *)imageIDArray {
    if (!_imageIDArray) {
        _imageIDArray = [[NSMutableArray alloc] init];
    }
    return _imageIDArray;
}

- (NSMutableArray *)todaySelectImgArray {
    if (!_todaySelectImgArray) {
        _todaySelectImgArray = [[NSMutableArray alloc] init];
    }
    return _todaySelectImgArray;
}

- (NSMutableArray *)todayImageIDArray {
    if (!_todayImageIDArray) {
        _todayImageIDArray = [[NSMutableArray alloc] init];
    }
    return _todayImageIDArray;
}

- (NSMutableArray *)fileIDArray {
    if (!_fileIDArray) {
        _fileIDArray = [[NSMutableArray alloc] init];
    }
    return _fileIDArray;
}

- (NSMutableString *)fileIDString {
    if (!_fileIDString) {
        _fileIDString = [[NSMutableString alloc] initWithString:@","];
    }
    return _fileIDString;
}

@end
