//
//  Mine_Notice_NotReadCount_Num_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/8/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Mine_Notice_NotReadCount_Num_Request.h"

/** 总未读消息数量 需登录 */
@implementation Mine_Notice_NotReadCount_Num_Request

- (NSString *)requestUrl {
    return @"ec/Notice/Notice_NotReadCount_Num";
}

@end
