//
//  PK_Target_ADD_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Target_ADD_Request.h"

@implementation PK_Target_ADD_Request {
    NSString *_startDate;
    NSString *_endDate;
    NSInteger _projectID;
    NSInteger _reportNum;
}

- (id)initWithStartDate:(NSString *)startDate EndDate:(NSString *)endDate ProjectID:(NSInteger)projectID ReportNum:(NSInteger)reportNum {
    if (self = [super init]) {
        _startDate = startDate;
        _endDate = endDate;
        _projectID = projectID;
        _reportNum = reportNum;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Target/Target_ADD";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"StartDate":_startDate,
             @"EndDate":_endDate,
             @"ProjectID":@(_projectID),
             @"ReportNum":@(_reportNum)};
}

@end
