//
//  ETPKProjectRecordModel.h
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPKProjectRecordModel : JSONModel

/** 汇报时间 */
@property (nonatomic, strong) NSString<Optional> *CreateDate;
/** 项目图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 项目ID */
@property (nonatomic, strong) NSString<Optional> *ProjectID;
/** 项目名称 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 项目单位 */
@property (nonatomic, strong) NSString<Optional> *ProjectUnit;
/** 排名 */
@property (nonatomic, strong) NSString<Optional> *Ranking;
/** 汇报天数 */
@property (nonatomic, strong) NSString<Optional> *ReportDays;
/** 汇报次数 */
@property (nonatomic, strong) NSString<Optional> *ReportFre;
/** 汇报数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum;
/** 汇报总数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum_All;
/** 本月汇报总数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum_Month;

@end
