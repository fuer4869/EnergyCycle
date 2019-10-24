//
//  PK_Report_Post_Add.h
//  能量圈
//
//  Created by 王斌 on 2017/8/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 每日汇总发帖 返回false是没有发帖,返回true是发帖成功 需登录 */
@interface PK_Report_Post_Add : ETRequest

- (id)initWithPostContent:(NSString *)postContent FileIDs:(NSString *)fileIDs;

@end
