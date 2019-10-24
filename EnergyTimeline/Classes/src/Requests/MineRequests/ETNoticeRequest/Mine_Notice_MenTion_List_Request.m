//
//  Mine_Notice_MenTion_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Mine_Notice_MenTion_List_Request.h"

@implementation Mine_Notice_MenTion_List_Request {
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
    return @"ec/Notice/Notice_MenTion_List";
}

- (id)requestArgument {
    return @{@"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
