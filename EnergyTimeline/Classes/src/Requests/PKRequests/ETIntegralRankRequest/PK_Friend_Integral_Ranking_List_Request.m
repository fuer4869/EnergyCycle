//
//  PK_Friend_Integral_Ranking_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/12/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Friend_Integral_Ranking_List_Request.h"

/** 积分排行榜 -- 好友排行 需登录 */
@implementation PK_Friend_Integral_Ranking_List_Request {
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
    return @"ec/User/Friend_Integral_Ranking_List";
}

- (id)requestArgument {
    return @{@"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
