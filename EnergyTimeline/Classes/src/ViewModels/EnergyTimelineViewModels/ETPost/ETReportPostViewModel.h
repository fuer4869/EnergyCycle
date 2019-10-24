//
//  ETReportPostViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "DraftsModel.h"
#import "ETShareTableViewCellViewModel.h"
#import "ETFirstEnterModel.h"

@interface ETReportPostViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *reloadSubject;

@property (nonatomic, strong) RACSubject *reloadCollectionViewSubject;

@property (nonatomic, strong) RACSubject *reloadTagCollectionViewSubject;

@property (nonatomic, strong) RACSubject *dismissSubject;

@property (nonatomic, strong) RACSubject *pickerSubjet;

@property (nonatomic, strong) RACSubject *removePictureSubject;

@property (nonatomic, strong) RACSubject *loadDraftSubject;

@property (nonatomic, strong) RACSubject *saveOrUpdateDraftSubject;

@property (nonatomic, strong) RACSubject *shareSubject;

@property (nonatomic, strong) RACSubject *firstEnterEndSubject;

@property (nonatomic, strong) RACCommand *firstEnterDataCommand;

@property (nonatomic, strong) RACCommand *firstEnterUpdCommand;

@property (nonatomic, strong) RACCommand *tagCommand;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *reportCommand;

@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, strong) NSMutableArray *selectImgArray;

@property (nonatomic, strong) NSMutableArray *imageIDArray;

@property (nonatomic, strong) NSMutableArray *fileIDArray;

@property (nonatomic, strong) NSMutableString *fileIDString;

@property (nonatomic, strong) DraftsModel *draftModel;

@property (nonatomic, strong) DraftsModel *lastDraftModel;

@property (nonatomic, strong) ETFirstEnterModel *firstEnterModel; // 提醒模型;

@property (nonatomic, strong) ETShareTableViewCellViewModel *shareViewModel;

@property (nonatomic, copy) NSString *postContent;

@property (nonatomic, assign) NSInteger postType;

@property (nonatomic, assign) NSInteger tagID;

@property (nonatomic, strong) NSMutableString *toUsers;

#pragma mark -- 将要删除的 --

@property (nonatomic, strong) RACSubject *contactVCSubject;

@property (nonatomic, strong) NSMutableArray *contacts;

@end
