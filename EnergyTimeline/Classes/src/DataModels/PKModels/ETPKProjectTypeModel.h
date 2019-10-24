//
//  ETPKProjectTypeModel.h
//  能量圈
//
//  Created by 王斌 on 2018/1/8.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPKProjectTypeModel : JSONModel

/** 项目分类ID */
@property (nonatomic, strong) NSString<Optional> *ProjectTypeID;
/** 项目分类名称 */
@property (nonatomic, strong) NSString<Optional> *ProjectTypeName;
/** 项目分类图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;


@end
