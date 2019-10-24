//
//  ETDailyPKPageViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKPageViewModel.h"
#import "ETPKProjectModel.h"
#import "PK_Project_List_Requset.h"
#import "File_Upload_Request.h"
#import "User_PKCoverImg_Upd_Request.h"

#import "ETDailyPKViewModel.h"

@implementation ETDailyPKPageViewModel

- (void)et_initialize {
    [self.uploadPKCoverImgCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue]) {
            NSLog(@"图片更换成功");
        }
    }];
}

#pragma mark -- lazyLoad --

- (RACCommand *)projectListCommand {
    if (!_projectListCommand) {
        _projectListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                PK_Project_List_Requset *projectListRequest = [[PK_Project_List_Requset alloc] init];
                [projectListRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    if ([request.responseObject[@"Status"] integerValue] == 200 && [request.responseObject[@"Data"] count]) {
                        NSMutableArray *datas = [[NSMutableArray alloc] init];
                        NSMutableArray *titles = [[NSMutableArray alloc] init];
                        for (NSDictionary *dic in request.responseObject[@"Data"]) {
                            ETPKProjectModel *model = [[ETPKProjectModel alloc] initWithDictionary:dic error:nil];
                            ETDailyPKViewModel *viewModel = [[ETDailyPKViewModel alloc] init];
                            viewModel.refreshSubject = self.refreshSubject;
                            viewModel.submitSubject = self.submitSubject;
                            viewModel.setupSubject = self.setupSubject;
                            viewModel.model = model;
                            [datas addObject:viewModel];
                            [titles addObject:model.ProjectName];
                        }
                        self.dataArray = datas;
                        self.titleArray = titles;
                    }
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
    return _projectListCommand;
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

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSArray alloc] init];
    }
    return _titleArray;
}

- (NSArray *)coverImgArray {
    if (!_coverImgArray) {
        _coverImgArray = [[NSArray alloc] init];
    }
    return _coverImgArray;
}

- (RACSubject *)pageViewCellClickSubject {
    if (!_pageViewCellClickSubject) {
        _pageViewCellClickSubject = [RACSubject subject];
    }
    return _pageViewCellClickSubject;
}

- (RACSubject *)removePageViewSubject {
    if (!_removePageViewSubject) {
        _removePageViewSubject = [RACSubject subject];
    }
    return _removePageViewSubject;
}

- (RACSubject *)refreshSubject {
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject subject];
    }
    return _refreshSubject;
}

- (RACSubject *)submitSubject {
    if (!_submitSubject) {
        _submitSubject = [RACSubject subject];
    }
    return _submitSubject;
}

- (RACSubject *)setupSubject {
    if (!_setupSubject) {
        _setupSubject = [RACSubject subject];
    }
    return _setupSubject;
}

- (RACSubject *)popSubject {
    if (!_popSubject) {
        _popSubject = [RACSubject subject];
    }
    return _popSubject;
}

@end
