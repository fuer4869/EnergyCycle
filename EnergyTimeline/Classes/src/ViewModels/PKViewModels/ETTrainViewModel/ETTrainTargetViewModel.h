//
//  ETTrainTargetViewModel.h
//  能量圈
//
//  Created by 王斌 on 2018/3/26.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETPKProjectModel.h"

@interface ETTrainTargetViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *projectGetCommand;

@property (nonatomic, strong) RACCommand *trainAddCommand;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *backSubject;

@property (nonatomic, strong) RACSubject *nextSubject;

@property (nonatomic, strong) ETPKProjectModel *model;

/** 项目ID */
@property (nonatomic, assign) NSInteger projectID;
/** 训练可选目标数量数组 */
@property (nonatomic, strong) NSArray *trainArray;
/** 训练目标数量下标 */
@property (nonatomic, assign) NSInteger *trainRow;
/** 训练目标数量 */
@property (nonatomic, copy) NSString *trainTarget;
/** 弹出框类型 */
@property (nonatomic, assign) NSInteger popState;
/** 教练名 */
@property (nonatomic, copy) NSString *coach;
/** bgm类型 */
@property (nonatomic, copy) NSString *bgm;
/** 训练ID */
@property (nonatomic, assign) NSInteger trainID;

@end
