//
//  Find_Radio_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/6.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Find_Radio_List_Request.h"

/** 电台列表 不需登录 */
@implementation Find_Radio_List_Request {
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Radio/Radio_List";
}

- (id)requestArgument {
    return @{@"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
