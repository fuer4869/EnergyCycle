//
//  DraftsModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JKDBModel.h"

@interface DraftsModel : JKDBModel

/** 上下文内容 */
@property (nonatomic, copy) NSString *context;
/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 首张图片 */
@property (nonatomic, copy) NSString *imgLocalURL;
/** @的用户 */
@property (nonatomic, copy) NSString *contacts;
/** 是否为最新 */
@property (nonatomic, assign) BOOL isNew;

@end
