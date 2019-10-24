//
//  PK_ReportProject_Del_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/1/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_ReportProject_Del_Request.h"

/** 删除项目 */
@implementation PK_ReportProject_Del_Request {
    NSInteger _projectID;
}

- (id)initWithProjectID:(NSInteger)projectID {
    if (self = [super init]) {
        _projectID = projectID;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (NSString *)requestUrl {
    return @"ec/pk/ReportProject_Del";
}

- (id)requestArgument {
    return @{@"ProjectID" : @(_projectID)};
}

@end
