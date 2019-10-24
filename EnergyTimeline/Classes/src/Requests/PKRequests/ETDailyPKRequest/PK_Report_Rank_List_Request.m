//
//  PK_Report_Rank_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Report_Rank_List_Request.h"

/** 每日PK排行榜 需登录 */
@implementation PK_Report_Rank_List_Request {
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
    return @"ec/PK/Report_Rank_List";
}

- (id)requestArgument {
    return @{@"ProjectID":@(_projectID),
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
