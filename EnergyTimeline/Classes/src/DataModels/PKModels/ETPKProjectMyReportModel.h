//
//  ETPKProjectMyReportModel.h
//  能量圈
//
//  Created by 王斌 on 2017/12/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPKProjectMyReportModel : JSONModel

/** 项目图片路径 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 是否发布动态 */
@property (nonatomic, strong) NSString<Optional> *Is_SenPost;
/** 用户项目占领图 */
@property (nonatomic, strong) NSString<Optional> *PKCoverImg;
/** 项目名称 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 项目排名 */
@property (nonatomic, strong) NSString<Optional> *Ranking;
/** 总汇报次数 */
@property (nonatomic, strong) NSString<Optional> *ReportFre_All;
/** 本月汇报次数 */
@property (nonatomic, strong) NSString<Optional> *ReportFre_Month;
/** 汇报总数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum_All;
/** 本月汇报总数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum_Month;
/** 上升数量 */
@property (nonatomic, strong) NSString<Optional> *UpNum;
/** 项目单位 */
@property (nonatomic, strong) NSString<Optional> *ProjectUnit;
/** 上限 */
@property (nonatomic, strong) NSString<Optional> *Limit;
/** 汇报ID */
@property (nonatomic, strong) NSString<Optional> *ReportID;

@end
