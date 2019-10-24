//
//  PK_MyBadge_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_MyBadge_List_Request.h"

/** 我获得的徽章 需登录 */
@implementation PK_MyBadge_List_Request

- (NSString *)requestUrl {
    return @"ec/Badge/MyBadge_List";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

@end
