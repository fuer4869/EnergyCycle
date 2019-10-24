//
//  ETPKStatisticsModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPKStatisticsModel : JSONModel

/** 项目 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 数量 */
@property (nonatomic, strong) NSString<Optional> *Num;
/** 单位 */
@property (nonatomic, strong) NSString<Optional> *Unit;

@end
