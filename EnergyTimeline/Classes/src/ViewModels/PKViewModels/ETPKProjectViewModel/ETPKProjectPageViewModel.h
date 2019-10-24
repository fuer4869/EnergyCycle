//
//  ETPKProjectPageViewModel.h
//  能量圈
//
//  Created by 王斌 on 2018/1/10.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETFirstEnterModel.h"

@interface ETPKProjectPageViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *projectListCommand; // 项目列表

@property (nonatomic, strong) RACCommand *projectTypeListCommand; // 项目分类列表

@property (nonatomic, strong) RACCommand *firstEnterDataCommand; // 提醒数据

@property (nonatomic, strong) RACCommand *firstEnterUpdCommand; // 更新提醒

@property (nonatomic, strong) RACCommand *uploadFileCommand; // 上传图片

@property (nonatomic, strong) RACCommand *uploadPKCoverImgCommand; // 上传pk封面图

@property (nonatomic, strong) RACCommand *projectDelCommand; // 删除pk项目

@property (nonatomic, strong) RACSubject *refreshEndSubject; // 获取数据后

@property (nonatomic, strong) RACSubject *firstEnterEndSubject; // 提醒数据获取后

@property (nonatomic, strong) RACSubject *setupPKCoverSubject; // 设置封面背景

@property (nonatomic, strong) RACSubject *refreshSubject; // 刷新

@property (nonatomic, strong) RACSubject *backSubject; // 返回

@property (nonatomic, strong) RACSubject *projectListCellClickSubject; // 项目列表点击

@property (nonatomic, strong) RACSubject *removeProjectListViewSubject; // 删除项目分类列表

@property (nonatomic, strong) ETFirstEnterModel *firstEnterModel; // 提醒模型

@property (nonatomic, assign) BOOL allProject; // 是否为所有项目

@property (nonatomic, assign) BOOL addSubviews; // 是否添加子视图

@property (nonatomic, assign) BOOL showProjectList; // 项目分类列表是否展示

@property (nonatomic, assign) NSInteger currentIndex; // 当前视图的下标

@property (nonatomic, strong) NSArray *dataArray; // 所有项目viewModel数组

@property (nonatomic, strong) NSArray *titleArray; // 所有项目名数组

@property (nonatomic, strong) NSArray *projectTypeArray; // 项目分类名数组

@property (nonatomic, strong) NSArray *projectTypeDataArray; // 所有项目模型数组(含分类)

@property (nonatomic, strong) NSArray *coverImgArray;

@end
