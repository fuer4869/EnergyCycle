//
//  PK_Likes_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/22.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Likes_Add_Request.h"

/** PK点赞 需登录 */
@implementation PK_Likes_Add_Request {
    NSInteger _reportID;
}

- (id)initWithReportID:(NSInteger)reportID {
    if (self = [super init]) {
        _reportID = reportID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/Likes_Add";
}

- (id)requestArgument {
    return @{@"ReportID":@(_reportID)};
}

@end
