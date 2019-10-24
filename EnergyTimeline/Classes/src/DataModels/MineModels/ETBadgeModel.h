//
//  ETBadgeModel.h
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETBadgeModel : JSONModel

/** 获得徽章需要时间 */
@property (nonatomic, strong) NSString<Optional> *BadgeDays;
/** 徽章ID */
@property (nonatomic, strong) NSString<Optional> *BadgeID;
/** 介绍 */
@property (nonatomic, strong) NSString<Optional> *BadgeName;
/** 徽章类型 */
@property (nonatomic, strong) NSString<Optional> *BadgeType;
/** 地址ID */
@property (nonatomic, strong) NSString<Optional> *FileID;
/** 徽章图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 灰色徽章图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath_Gray;
/** 是否获得 */
@property (nonatomic, strong) NSString<Optional> *Is_Have;
/** 获得的人 */
@property (nonatomic, strong) NSString<Optional> *HaveNum;

@end
