//
//  PKProjectChartModel.h
//  能量圈
//
//  Created by 王斌 on 2017/8/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface PKProjectChartModel : JSONModel

/** pk记录创建时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** pk记录数值 */
@property (nonatomic, strong) NSString<Optional> *ReportNum;

@end
