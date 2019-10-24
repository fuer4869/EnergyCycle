//
//  PK_Project_Clock_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/1/25.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Project_Clock_Get_Request.h"

/** 获取提醒信息 */
@implementation PK_Project_Clock_Get_Request {
    NSInteger _projectID;
}

- (id)initWithProjectID:(NSInteger)projectID {
    if (self = [super init]) {
        _projectID = projectID;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypeGet;
}

- (NSString *)requestUrl {
    return @"ec/pk/Project_Clock_Get";
}

- (id)requestArgument {
    return @{@"ProjectID":@(_projectID)};
}

@end
