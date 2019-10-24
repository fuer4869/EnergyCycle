//
//  ETSysModel.h
//  能量圈
//
//  Created by 王斌 on 2017/9/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETSysModel : JSONModel

/** 创建时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 开始时间 */
@property (nonatomic, strong) NSString<Optional> *StartDate;
/** 结束时间 */
@property (nonatomic, strong) NSString<Optional> *EndData;
/** 文件ID */
@property (nonatomic, strong) NSString<Optional> *FileID;
/** 文件地址 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 是否为老版本 */
@property (nonatomic, strong) NSString<Optional> *Is_Old;
/** 通知类型 1.更新 2.功能 3.活动 */
@property (nonatomic, strong) NSString<Optional> *NoticeType;
/** 通知链接 */
@property (nonatomic, strong) NSString<Optional> *NoticeUrl;
/** 通知内容 */
@property (nonatomic, strong) NSString<Optional> *Notice_Content;
/** app通知ID */
@property (nonatomic, strong) NSString<Optional> *Sys_NoticeID;
/** 新功能位置 */
@property (nonatomic, strong) NSString<Optional> *Target;
/** 版本ID */
@property (nonatomic, strong) NSString<Optional> *VersionID;

@end
