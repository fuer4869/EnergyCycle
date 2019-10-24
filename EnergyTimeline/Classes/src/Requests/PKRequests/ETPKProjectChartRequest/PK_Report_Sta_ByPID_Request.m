//
//  PK_Report_Sta_ByPID_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/8/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Report_Sta_ByPID_Request.h"

/** 根据项目ID获取汇报详情_需要时间参数的列表 */
@implementation PK_Report_Sta_ByPID_Request {
    NSInteger _projectID;
    NSInteger _userID;
    NSString *_startDate;
    NSString *_endDate;
}

- (id)initWithProjectID:(NSInteger)projectID UserID:(NSInteger)userID StartDate:(NSString *)startDate EndDate:(NSString *)endDate {
    if (self = [super init]) {
        _projectID = projectID;
        _userID = userID;
        _startDate = startDate;
        _endDate = endDate;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/Report_Sta_ByPID";
}

- (id)requestArgument { 
    return @{@"ProjectID":@(_projectID),
             @"UserID":@(_userID),
             @"StartDate":_startDate,
             @"EndDate":_endDate};
}

@end
