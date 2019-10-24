//
//  User_My_Attention_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_My_Attention_List_Request.h"

/** 我关注的 需登录 */
@implementation User_My_Attention_List_Request {
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
    return @"ec/User/My_Attention_List";
}

- (id)requestArgument {
    return @{@"ToUserID":@(_toUserID),
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
