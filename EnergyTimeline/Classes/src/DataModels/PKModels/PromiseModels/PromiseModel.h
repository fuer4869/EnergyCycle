//
//  PromiseModel.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "JSONModel.h"

@interface PromiseModel : JSONModel

//@property (nonatomic, strong) NSString<Optional> *TargetID; // 目标ID
//@property (nonatomic, strong) NSString<Optional> *UserID; // 用户ID
//@property (nonatomic, strong) NSString<Optional> *FinishDays; // 完成天数
//@property (nonatomic, strong) NSString<Optional> *AllDays; // 目标时长
//@property (nonatomic, strong) NSString<Optional> *StartDate; // 开始时间
//@property (nonatomic, strong) NSString<Optional> *EndDate; // 结束时间
//@property (nonatomic, strong) NSString<Optional> *P_UNIT; // 单位
//@property (nonatomic, strong) NSString<Optional> *ProjectName; // 目标名称
//@property (nonatomic, strong) NSString<Optional> *ReportNum; // 每日目标数
//@property (nonatomic, strong) NSString<Optional> *RowNum; // 列表位数
//@property (nonatomic, strong) NSString<Optional> *RowsCount; // 列表总数
//@property (nonatomic, strong) NSString<Optional> *P_PICURL; // 项目图片

/** 创建时间 */
@property (nonatomic, strong) NSString<Optional> *CreateDate;
/** 开始时间 */
@property (nonatomic, strong) NSString<Optional> *StartDate;
/** 结束时间 */
@property (nonatomic, strong) NSString<Optional> *EndDate;
/** 项目图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 完成天数 */
@property (nonatomic, strong) NSString<Optional> *FinishDays;
/** 是否删除 */
@property (nonatomic, strong) NSString<Optional> *Is_Del;
/** 是否完成 */
@property (nonatomic, strong) NSString<Optional> *Is_Finish;
/** 项目ID */
@property (nonatomic, strong) NSString<Optional> *ProjectID;
/** 项目名称 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 项目单位 */
@property (nonatomic, strong) NSString<Optional> *ProjectUnit;
/** 每日目标数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum;
/** 目标ID */
@property (nonatomic, strong) NSString<Optional> *TargetID;
/** 目标总天数 */
@property (nonatomic, strong) NSString<Optional> *TotalDays;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

@end
