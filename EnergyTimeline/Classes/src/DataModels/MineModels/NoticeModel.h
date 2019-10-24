//
//  NoticeModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NoticeModel : JSONModel

/** 通知时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 是否已读 */
@property (nonatomic, strong) NSString<Optional> *Is_Read;
/** 通知内容 */
@property (nonatomic, strong) NSString<Optional> *NoticeContent;
/** 通知事件 */
@property (nonatomic, strong) NSString<Optional> *NoticeEvent;
/** 通知ID */
@property (nonatomic, strong) NSString<Optional> *NoticeID;
/** 通知类型 */
@property (nonatomic, strong) NSString<Optional> *NoticeType;
/** 源ID */
@property (nonatomic, strong) NSString<Optional> *SourceID;
/** 源名称 */
@property (nonatomic, strong) NSString<Optional> *SourceName;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

@end
