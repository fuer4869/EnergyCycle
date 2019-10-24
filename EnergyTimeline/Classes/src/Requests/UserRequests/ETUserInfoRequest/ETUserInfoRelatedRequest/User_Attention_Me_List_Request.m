//
//  User_Attention_Me_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_Attention_Me_List_Request.h"

/** 关注我的 需登录 */
@implementation User_Attention_Me_List_Request {
    NSInteger _type;
    NSInteger _toUserID;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (id)initWithType:(ETFans)type ToUserID:(NSInteger)toUserID PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _type = type;
        _toUserID = toUserID;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/Attention_Me_List";
}

- (id)requestArgument {
    return @{@"Type":@(_type),
             @"ToUserID":@(_toUserID),
             @"PageIndex":@(_pageIndex),
             @"PageSize":@(_pageSize)};
}

@end
