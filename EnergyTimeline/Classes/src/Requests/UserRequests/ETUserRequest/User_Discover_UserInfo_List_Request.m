//
//  User_Discover_UserInfo_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_Discover_UserInfo_List_Request.h"

/** 发现模块用户搜索 需登录 */
@implementation User_Discover_UserInfo_List_Request {
    NSString *_searchKey;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (id)initWithSearchKey:(NSString *)searchKey PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _searchKey = searchKey;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/Discover_UserInfo_List";
}

- (id)requestArgument {
    return @{@"SearchKey":_searchKey,
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end