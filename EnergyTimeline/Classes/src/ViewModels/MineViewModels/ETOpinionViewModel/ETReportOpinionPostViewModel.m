//
//  ETReportOpinionPostViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportOpinionPostViewModel.h"
#import "File_Upload_Request.h"
#import "Post_Add_Request.h"

#import "NSString+Regex.h"
/** 图片压缩 */
#import "UIImage+Compression.h"

@implementation ETReportOpinionPostViewModel

- (void)et_initialize {
    @weakify(self)
    [self.reportCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
//        Post_Add_Request *reportRequest = [[Post_Add_Request alloc] initWithPostContent:self.postContent FileIDs:self.fileIDString];
        Post_Add_Request *postRequest = [[Post_Add_Request alloc] initWithPostContent:self.postContent PostType:8 FileIDs:self.fileIDString ToUsers:@"" TagID:0];
        [postRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:ETWindow animated:YES];
            if ([request.responseObject[@"Status"] integerValue] == 200) {
                [self.dismissSubject sendNext:request.responseObject];
                [MBProgressHUD showMessage:@"上传成功"];
            }
        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:ETWindow animated:YES];
            [MBProgressHUD showMessage:@"发布失败"];
        }];
    }];
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

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
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
