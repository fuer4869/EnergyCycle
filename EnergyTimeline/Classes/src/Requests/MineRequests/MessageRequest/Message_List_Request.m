//
//  Message_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Message_List_Request.h"

/** 两个人的消息记录 */
@implementation Message_List_Request {
    NSInteger _toUserID;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (id)initWithToUserID:(NSInteger)toUserID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _toUserID = toUserID;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Message/Message_List";
}

- (id)requestArgument {
    return @{@"ToUserID":@(_toUserID),
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
