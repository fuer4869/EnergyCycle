//
//  ETReportPKViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKViewModel.h"
#import "File_Upload_Request.h"
#import "PK_Report_Add_Request.h"
#import "PK_v4_Report_Add_Request.h"

/** 提醒 */
#import "User_FirstEnter_Get_Request.h"
#import "User_FirstEnter_Upd_Request.h"

/** 图片压缩 */
#import "UIImage+Compression.h"

#import "ETReportPKProjectModel.h"

#import "ETRadioManager.h"

@implementation ETReportPKViewModel

- (void)et_initialize {
    
    NSArray *arr = [ETReportPKProjectModel findAll];
    for (ETReportPKProjectModel *dbModel in arr) {
        ETPKProjectModel *model = [[ETPKProjectModel alloc] init];
        model.ProjectID = dbModel.ProjectID;
        model.ProjectName = dbModel.ProjectName;
        model.ProjectUnit = dbModel.ProjectUnit;
        model.FilePath = dbModel.FilePath;
        model.ReportFre = dbModel.ReportFre;
        model.Limit = dbModel.ReportLimit;
        if ([model.ProjectID integerValue] != 35) { // 健康数据自动上传，所以健康的汇报项目隐藏
            [self.selectProjectArray addObject:model];
        }
    }
    
    @weakify(self)
    [self.reportCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        PK_v4_Report_Add_Request *reportRequest = [[PK_v4_Report_Add_Request alloc] initWithReport_Items:self.projectNumArray PostContent:self.postContent Is_Sync:ETBOOL(YES) FileIDs:self.fileIDString];
        [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
            if ([request.responseObject[@"Status"] integerValue] == 200) {
                if (self.fileIDArray.count) {
                    [self.firstEnterUpdCommand execute:@"Is_FirstPK_Pic"];
                }

//                [[ETRadioManager sharedInstance] playAudioType:ETAudioTypeReportPK];

//                [self.shareSubject sendNext:request.responseObject];
                NSMutableArray *projectArr = [[NSMutableArray alloc] init];
                for (ETPKProjectModel *model in self.selectProjectArray) {
                    ETReportPKProjectModel *dbModel = [[ETReportPKProjectModel alloc] init];
                    dbModel.ProjectID = model.ProjectID;
                    dbModel.ProjectName = model.ProjectName;
                    dbModel.ProjectUnit = model.ProjectUnit;
                    dbModel.FilePath = model.FilePath;
                    dbModel.ReportFre = model.ReportFre;
                    dbModel.ReportLimit = model.Limit;
                    [projectArr addObject:dbModel];
                }
                [ETReportPKProjectModel clearTable];
                [ETReportPKProjectModel saveObjects:projectArr];
                
//                [self.dismissSubject sendNext:nil];
                [self.reportCompletedSubject sendNext:request.responseObject];
                [MBProgressHUD hideHUDForView:ETWindow animated:YES];
//                [MBProgressHUD showMessage:@"上传成功"];
            } else {
                [MBProgressHUD hideHUDForView:ETWindow animated:YES];
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

- (RACSubject *)reloadSubject {
    if (!_reloadSubject) {
        _reloadSubject = [RACSubject subject];
    }
    return _reloadSubject;
}

- (RACSubject *)reloadCollectionViewSubject {
    if (!_reloadCollectionViewSubject) {
        _reloadCollectionViewSubject = [RACSubject subject];
    }
    return _reloadCollectionViewSubject;
}

- (RACSubject *)projectSubject {
    if (!_projectSubject) {
        _projectSubject = [RACSubject subject];
    }
    return _projectSubject;
}

- (RACSubject *)dismissSubject {
    if (!_dismissSubject) {
        _dismissSubject = [RACSubject subject];
    }
    return _dismissSubject;
}

- (RACSubject *)pickerSubject {
    if (!_pickerSubject) {
        _pickerSubject = [RACSubject subject];
    }
    return _pickerSubject;
}

- (RACSubject *)shareSubject {
    if (!_shareSubject) {
        _shareSubject = [RACSubject subject];
    }
    return _shareSubject;
}

- (RACSubject *)reportCompletedSubject {
    if (!_reportCompletedSubject) {
        _reportCompletedSubject = [RACSubject subject];
    }
    return _reportCompletedSubject;
}

- (RACSubject *)firstEnterEndSubject {
    if (!_firstEnterEndSubject) {
        _firstEnterEndSubject = [RACSubject subject];
    }
    return _firstEnterEndSubject;
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
        _uploadFileCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSMutableArray *imageArr = [NSMutableArray array];
                for (NSInteger i = 0; i < self.imageIDArray.count; i ++) {
                    UIImage *resultImage = [UIImage compressImage:self.selectImgArray[i] toKilobyte:1024];
                    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.5);
                    [imageArr addObject:imageData];
                }
                [File_Upload_Request uploadWithImageArr:imageArr success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    [self.fileIDArray addObject:responseObject[@"Data"][0]];
                    self.fileIDArray = responseObject[@"Data"];
                    for (NSInteger i = 0; i < self.imageIDArray.count; i ++) {
                        [self.fileIDString appendString:[NSString stringWithFormat:@"%@,", responseObject[@"Data"][i]]];
                    }
                    [subscriber sendNext:responseObject];
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

- (ETPKProjectModel *)projectModel {
    if (!_projectModel) {
        _projectModel = [[ETPKProjectModel alloc] init];
    }
    return _projectModel;
}

- (RACSubject *)textFieldSubject {
    if (!_textFieldSubject) {
        _textFieldSubject = [RACSubject subject];
    }
    return _textFieldSubject;
}

- (NSMutableArray *)selectImgArray {
    if (!_selectImgArray) {
        _selectImgArray = [[NSMutableArray alloc] init];
    }
    return _selectImgArray;
}

- (NSMutableArray *)selectProjectArray {
    if (!_selectProjectArray) {
        _selectProjectArray = [[NSMutableArray alloc] init];
    }
    return _selectProjectArray;
}

- (NSMutableArray *)projectNumArray {
    if (!_projectNumArray) {
        _projectNumArray = [[NSMutableArray alloc] init];
    }
    return _projectNumArray;
}

- (NSMutableArray *)imageIDArray {
    if (!_imageIDArray) {
        _imageIDArray = [[NSMutableArray alloc] init];
    }
    return _imageIDArray;
}

- (NSMutableArray *)fileIDArray {
    if (!_fileIDArray) {
        _fileIDArray = [[NSMutableArray alloc] init];
    }
    return _fileIDArray;
}

- (NSMutableString *)fileIDString {
    if (!_fileIDString) {
        _fileIDString = [[NSMutableString alloc] initWithString:@""];
    }
    return _fileIDString;
}

- (ETSyncPostTableViewCellViewModel *)syncPostViewModel {
    if (!_syncPostViewModel) {
        _syncPostViewModel = [[ETSyncPostTableViewCellViewModel alloc] init];
    }
    return _syncPostViewModel;
}

- (ETShareTableViewCellViewModel *)shareViewModel {
    if (!_shareViewModel) {
        _shareViewModel = [[ETShareTableViewCellViewModel alloc] init];
    }
    return _shareViewModel;
}

@end
