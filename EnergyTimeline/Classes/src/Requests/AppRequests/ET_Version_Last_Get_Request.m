//
//  ET_Version_Last_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/9/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ET_Version_Last_Get_Request.h"

/** 获取最新版本号 */
@implementation ET_Version_Last_Get_Request

- (NSString *)requestUrl {
    return @"ec/SysConfig/Version_Last_Get";
}

@end
