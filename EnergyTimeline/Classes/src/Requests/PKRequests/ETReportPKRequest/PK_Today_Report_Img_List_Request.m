//
//  PK_Today_Report_Img_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Today_Report_Img_List_Request.h"

/** 获取今天所有项目提交时的汇报的图片(最少为0张,最多获取9张) */
@implementation PK_Today_Report_Img_List_Request

- (NSString *)requestUrl {
    return @"ec/PK/Today_Report_Img_List";
}

@end
