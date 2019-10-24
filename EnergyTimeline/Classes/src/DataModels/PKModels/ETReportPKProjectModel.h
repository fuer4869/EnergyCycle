//
//  ETReportPKProjectModel.h
//  能量圈
//
//  Created by 王斌 on 2017/8/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JKDBModel.h"

@interface ETReportPKProjectModel : JKDBModel

/** 项目ID */
@property (nonatomic, copy) NSString *ProjectID;
/** 项目名称 */
@property (nonatomic, copy) NSString *ProjectName;
/** 项目单位 */
@property (nonatomic, copy) NSString *ProjectUnit;
/** 项目图片 */
@property (nonatomic, copy) NSString *FilePath;
/** 汇报数 */
@property (nonatomic, copy) NSString *ReportFre;
/** 汇报上限(Limit是保留字段, 所以改了名字) */
@property (nonatomic, copy) NSString *ReportLimit;

@end
