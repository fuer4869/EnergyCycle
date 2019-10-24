//
//  PK_Integral_Rank_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Integral_Rank_List_Request.h"

/** 积分排行榜 -- 世界排行 需登录 */
@implementation PK_Integral_Rank_List_Request {
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
    return @"ec/User/Integral_Rank_List";
}

- (id)requestArgument {
    return @{@"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
