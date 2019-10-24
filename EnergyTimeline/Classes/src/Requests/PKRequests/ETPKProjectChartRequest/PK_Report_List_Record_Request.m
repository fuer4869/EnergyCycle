//
//  PK_Report_List_Record_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/8/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Report_List_Record_Request.h"

/** 根据项目ID获取汇报详情_获取列表 */
@implementation PK_Report_List_Record_Request {
    NSInteger _projectID;
    NSInteger _userID;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (id)initWithProjectID:(NSInteger)projectID UserID:(NSInteger)userID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _projectID = projectID;
        _userID = userID;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/Report_List_Record";
}

- (id)requestArgument {
    return @{@"ProjectID":@(_projectID),
             @"UserID":@(_userID),
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
