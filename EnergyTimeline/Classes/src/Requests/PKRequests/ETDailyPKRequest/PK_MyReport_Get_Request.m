//
//  PK_MyReport_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_MyReport_Get_Request.h"

/** 我的汇报信息 需登录 */
@implementation PK_MyReport_Get_Request {
    NSInteger _projectID;
}

- (id)initWithProjectID:(NSInteger)projectID {
    if (self = [super init]) {
        _projectID = projectID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/MyReport_Get";
}

- (id)requestArgument {
    return @{@"ProjectID":@(_projectID)};
}

@end
