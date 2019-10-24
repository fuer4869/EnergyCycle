//
//  PK_Likes_Add_Limit_One_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/1/22.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Likes_Add_Limit_One_Request.h"

/** 喜欢(提交上限为1的项目,例如:戒游戏,戒网络小说) */
@implementation PK_Likes_Add_Limit_One_Request {
    NSInteger _toUserID;
    NSInteger _projectID;
}

- (id)initWithToUserID:(NSInteger)toUserID ProjectID:(NSInteger)projectID {
    if (self = [super init]) {
        _toUserID = toUserID;
        _projectID = projectID;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypeGet;
}

- (NSString *)requestUrl {
    return @"ec/pk/Likes_Add_Limit_One";
}

- (id)requestArgument {
    return @{@"ToUserID" : @(_toUserID),
             @"ProjectID" : @(_projectID)};
}

@end
