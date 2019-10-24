//
//  ETPraiseModel.h
//  能量圈
//
//  Created by 王斌 on 2018/1/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPraiseModel : JSONModel

/** 创建时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 项目图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;

@property (nonatomic, strong) NSString<Optional> *HaveNum;
/** 表彰ID */
@property (nonatomic, strong) NSString<Optional> *PraiseID;
/** 表彰的数量 */
@property (nonatomic, strong) NSString<Optional> *PraiseNum;
/** 表彰ID */
@property (nonatomic, strong) NSString<Optional> *ProjectID;
/** 表彰项目名字 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 表彰项目单位 */
@property (nonatomic, strong) NSString<Optional> *ProjectUnit;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

@end
