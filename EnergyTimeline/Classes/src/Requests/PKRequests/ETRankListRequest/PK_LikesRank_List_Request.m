//
//  PK_LikesRank_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_LikesRank_List_Request.h"

/** PK点赞排行榜 需登录 */
@implementation PK_LikesRank_List_Request {
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
    return @"ec/PK/PK_LikesRank_List";
}

- (id)requestArgument {
    return @{@"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
