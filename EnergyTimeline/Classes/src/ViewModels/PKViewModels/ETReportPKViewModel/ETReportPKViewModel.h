//
//  ETReportPKViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETSyncPostTableViewCellViewModel.h"
#import "ETShareTableViewCellViewModel.h"
#import "ETPKProjectModel.h"
#import "ETFirstEnterModel.h"

@interface ETReportPKViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *reloadSubject;

@property (nonatomic, strong) RACSubject *reloadCollectionViewSubject;

@property (nonatomic, strong) RACSubject *projectSubject;

@property (nonatomic, strong) RACSubject *dismissSubject;

@property (nonatomic, strong) RACSubject *pickerSubject;

@property (nonatomic, strong) RACSubject *shareSubject;

@property (nonatomic, strong) RACSubject *reportCompletedSubject;

@property (nonatomic, strong) RACSubject *firstEnterEndSubject;

@property (nonatomic, strong) RACCommand *firstEnterDataCommand;

@property (nonatomic, strong) RACCommand *firstEnterUpdCommand;

@property (nonatomic, strong) RACCommand *uploadFileCommand;

@property (nonatomic, strong) RACCommand *reportCommand;

@property (nonatomic, strong) ETPKProjectModel *projectModel;

@property (nonatomic, strong) RACSubject *textFieldSubject;

@property (nonatomic, strong) NSMutableArray *selectProjectArray;

@property (nonatomic, strong) NSMutableArray *projectNumArray;

@property (nonatomic, strong) NSMutableArray *selectImgArray;

@property (nonatomic, strong) NSMutableArray *imageIDArray;

@property (nonatomic, strong) NSMutableArray *fileIDArray;

@property (nonatomic, strong) NSMutableString *fileIDString;

@property (nonatomic, strong) NSString *reportNum;

@property (nonatomic, strong) NSString *postContent;

@property (nonatomic, assign) BOOL onSync;

@property (nonatomic, strong) ETSyncPostTableViewCellViewModel *syncPostViewModel;

@property (nonatomic, strong) ETShareTableViewCellViewModel *shareViewModel;

@property (nonatomic, strong) ETFirstEnterModel *firstEnterModel;

//@property (nonatomic, strong) RACSubject 

@end
