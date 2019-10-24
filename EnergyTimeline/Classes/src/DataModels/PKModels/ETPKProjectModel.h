//
//  ETPKProjectModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPKProjectModel : JSONModel

/** 项目ID */
@property (nonatomic, strong) NSString<Optional> *ProjectID;
/** 项目分类ID */
@property (nonatomic, strong) NSString<Optional> *ProjectTypeID;
/** 项目名称 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 项目单位 */
@property (nonatomic, strong) NSString<Optional> *ProjectUnit;
/** 项目图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 汇报次数 */
@property (nonatomic, strong) NSString<Optional> *ReportFre;
/** 项目汇报总数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum;
/** 汇报时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 汇报上限 */
@property (nonatomic, strong) NSString<Optional> *Limit;
/** 训练目标上限 */
@property (nonatomic, strong) NSString<Optional> *Trainlimit;
/** 训练每组个数 */
@property (nonatomic, strong) NSString<Optional> *GroupNum;
/** 是否有训练功能 */
@property (nonatomic, strong) NSString<Optional> *Is_Train;

@end
