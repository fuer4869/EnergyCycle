//
//  PK_Likes_Add_Early_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/1/22.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Likes_Add_Early_Request.h"

/** 签到列表点赞 */
@implementation PK_Likes_Add_Early_Request {
    NSInteger _toUserID;
}

- (id)initWithToUserID:(NSInteger)toUserID {
    if (self = [super init]) {
        _toUserID = toUserID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/pk/Likes_Add_Early";
}

- (id)requestArgument {
    return @{@"ToUserID" : @(_toUserID)};
}

@end
