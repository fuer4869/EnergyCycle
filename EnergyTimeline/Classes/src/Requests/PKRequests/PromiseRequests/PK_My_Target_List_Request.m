//
//  PK_My_Target_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_My_Target_List_Request.h"

@implementation PK_My_Target_List_Request {
    NSInteger _type;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (id)initWithType:(NSInteger)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _type = type;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Target/My_Target_List";
}

- (id)requestArgument {
    return @{@"Type":@(_type),
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
