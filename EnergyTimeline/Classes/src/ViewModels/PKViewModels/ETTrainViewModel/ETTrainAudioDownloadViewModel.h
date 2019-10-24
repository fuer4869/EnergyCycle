//
//  ETTrainAudioDownloadViewModel.h
//  能量圈
//
//  Created by 王斌 on 2018/3/27.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETPKProjectTrainModel.h"

@interface ETTrainAudioDownloadViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *backSubject; // 返回

@property (nonatomic, strong) RACSubject *refreshSubject; // 刷新

@property (nonatomic, strong) RACSubject *downloadSubject; // 下载文件

@property (nonatomic, strong) RACSubject *startTrainSubject; // 开始训练

@property (nonatomic, strong) RACSubject *pauseDownloadSubject; // 暂停

@property (nonatomic, strong) RACSubject *startDownloadSubject; // 开始/继续

@property (nonatomic, strong) RACCommand *commonFileListCommand; // 获取公用文件列表

@property (nonatomic, strong) RACCommand *commonFileGetCommand; // 获取公用文件下载链接

@property (nonatomic, strong) RACCommand *projectFileListCommand; // 获取项目文件列表

@property (nonatomic, strong) RACCommand *projectFileGetCommand; // 获取项目文件下载链接(包含是否需要公用文件)

@property (nonatomic, strong) ETPKProjectTrainModel *model;

@property (nonatomic, assign) BOOL updateCommonFile; // 下载或更新公用文件

@property (nonatomic, assign) BOOL updateTrainFile; // 下载或更新项目训练文件

@property (nonatomic, assign) BOOL allowWWAN; // 允许蜂窝移动网络

@end
