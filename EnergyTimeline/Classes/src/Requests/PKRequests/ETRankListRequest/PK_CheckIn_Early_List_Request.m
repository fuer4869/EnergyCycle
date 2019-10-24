//
//  PK_CheckIn_Early_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_CheckIn_Early_List_Request.h"

/** 早起签到排行榜 需登录 */
@implementation PK_CheckIn_Early_List_Request {
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
    return @"ec/CheckIn/CheckIn_Early_List";
}

- (id)requestArgument {
    return @{@"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
