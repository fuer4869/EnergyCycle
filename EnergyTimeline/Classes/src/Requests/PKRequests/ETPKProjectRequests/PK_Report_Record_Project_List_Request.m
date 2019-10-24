//
//  PK_Report_Record_Project_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/12/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Report_Record_Project_List_Request.h"

/** 回顾PK记录 需登录 */
@implementation PK_Report_Record_Project_List_Request {
    NSInteger _projectID;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (id)initWithProjectID:(NSInteger)projectID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _projectID = projectID;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/pk/Report_Record_Project_List";
}

- (id)requestArgument {
    return @{@"ProjectID":@(_projectID),
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
