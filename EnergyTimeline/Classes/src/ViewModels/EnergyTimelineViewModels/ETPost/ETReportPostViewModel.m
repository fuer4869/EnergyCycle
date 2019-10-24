//
//  ETReportPostViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPostViewModel.h"
#import "Post_Tag_List_Request.h"
#import "File_Upload_Request.h"
#import "Post_Add_Request.h"

/** 提醒 */
#import "User_FirstEnter_Get_Request.h"
#import "User_FirstEnter_Upd_Request.h"

#import "UserModel.h"
#import "PostTagModel.h"

/** 图片压缩 */
#import "UIImage+Compression.h"

#import "ETRadioManager.h"

@implementation ETReportPostViewModel

- (void)et_initialize {
    @weakify(self)
    [[self.saveOrUpdateDraftSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.draftModel) {
            DraftsModel *model = [[DraftsModel alloc] init];
            model.isNew = YES;
            self.draftModel = model;
        }
        self.draftModel.context = self.postContent;
        self.draftModel.time = [[NSDate date] jk_stringWithFormat:@"YYY-MM-dd HH:mm:ss"];
        NSMutableArray *keys = [NSMutableArray array];
        for (NSInteger i = 0; i < self.selectImgArray.count; i++) {
            NSString *key = self.imageIDArray[i];
            UIImage *img = self.selectImgArray[i];
            if (img) {
                [[SDImageCache sharedImageCache] storeImage:img forKey:key toDisk:YES];
            }
            [keys addObject:key];
        }
        if (self.contacts.count) {
            NSString *contact = @"";
            for (UserModel *user in self.contacts) {
                contact = [contact stringByAppendingString:[NSString stringWithFormat:@"%@,", user.UserID]];
            }
            self.draftModel.contacts = contact;
        }
        NSString *filePath = [[NSDate date] jk_stringWithFormat:@"YYYYMMddHHmmss"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *plistPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filePath]];
        [keys writeToFile:plistPath atomically:YES];
        self.draftModel.imgLocalURL = filePath;
        [self.draftModel saveOrUpdate];
    }];
    
    [self.tagCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                PostTagModel *model = [[PostTagModel alloc] initWithDictionary:dic error:nil];
                [array addObject:model];
            }
            self.tagArray = array;
        }
        [self.reloadCollectionViewSubject sendNext:nil];
    }];
    
    [self.reportCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        for (UserModel *model in self.contacts) {
            [self.toUsers appendString:[NSString stringWithFormat:@"%@,", model.UserID]];
        }
        Post_Add_Request *reportRequest = [[Post_Add_Request alloc] initWithPostContent:self.postContent PostType:self.postType FileIDs:self.fileIDString ToUsers:self.toUsers TagID:self.tagID];
        [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:ETWindow animated:YES];
//            [[ETRadioManager sharedInstance] playAudioType:ETAudioTypeReportPost];
            if ([request.responseObject[@"Status"] integerValue] == 200) {
                if (self.fileIDArray.count) {
                    [self.firstEnterUpdCommand execute:@"Is_First_Post_Pic"];
                }
                
                [self.shareSubject sendNext:request.responseObject];
                [self.dismissSubject sendNext:nil];
                [MBProgressHUD showMessage:@"上传成功"];
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

- (RACSubject *)reloadTagCollectionViewSubject {
    if (!_reloadTagCollectionViewSubject) {
        _reloadTagCollectionViewSubject = [RACSubject subject];
    }
    return _reloadTagCollectionViewSubject;
}

- (RACSubject *)dismissSubject {
    if (!_dismissSubject) {
        _dismissSubject = [RACSubject subject];
    }
    return _dismissSubject;
}

- (RACSubject *)pickerSubjet {
    if (!_pickerSubjet) {
        _pickerSubjet = [RACSubject subject];
    }
    return _pickerSubjet;
}

- (RACSubject *)removePictureSubject {
    if (!_removePictureSubject) {
        _removePictureSubject = [RACSubject subject];
    }
    return _removePictureSubject;
}

- (RACSubject *)loadDraftSubject {
    if (!_loadDraftSubject) {
        _loadDraftSubject = [RACSubject subject];
    }
    return _loadDraftSubject;
}

- (RACSubject *)saveOrUpdateDraftSubject {
    if (!_saveOrUpdateDraftSubject) {
        _saveOrUpdateDraftSubject = [RACSubject subject];
    }
    return _saveOrUpdateDraftSubject;
}

- (RACSubject *)shareSubject {
    if (!_shareSubject) {
        _shareSubject = [RACSubject subject];
    }
    return _shareSubject;
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

- (RACCommand *)tagCommand {
    if (!_tagCommand) {
        _tagCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                Post_Tag_List_Request *tagListRequest = [[Post_Tag_List_Request alloc] init];
                [tagListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _tagCommand;
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
//                    [self.fileIDArray addObject:responseObject[@"Data"]];
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

- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [[NSMutableArray alloc] init];
    }
    return _tagArray;
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
        _fileIDString = [[NSMutableString alloc] initWithString:@""];
    }
    return _fileIDString;
}

- (ETShareTableViewCellViewModel *)shareViewModel {
    if (!_shareViewModel) {
        _shareViewModel = [[ETShareTableViewCellViewModel alloc] init];
    }
    return _shareViewModel;
}

- (NSMutableString *)toUsers {
    if (!_toUsers) {
        _toUsers = [[NSMutableString alloc] initWithString:@""];
    }
    return _toUsers;
}

#pragma mark -- 将要删除的 --

- (RACSubject *)contactVCSubject {
    if (!_contactVCSubject) {
        _contactVCSubject = [RACSubject subject];
    }
    return _contactVCSubject;
}

- (NSMutableArray *)contacts {
    if (!_contacts) {
        _contacts = [[NSMutableArray alloc] init];
    }
    return _contacts;
}



@end
