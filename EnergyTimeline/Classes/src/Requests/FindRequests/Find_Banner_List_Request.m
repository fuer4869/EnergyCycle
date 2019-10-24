//
//  Find_Banner_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Find_Banner_List_Request.h"

/** Banner 列表 需登录 */
@implementation Find_Banner_List_Request

- (NSString *)requestUrl {
    return @"ec/Banner/Banner_List";
}

@end
