//
//  User_CoverImg_Upd_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_CoverImg_Upd_Request.h"

/** 修改个人中心背景图 需登录 */
@implementation User_CoverImg_Upd_Request {
    NSInteger _fileID;
}

- (id)initWithFileID:(NSInteger)fileID {
    if (self = [super init]) {
        _fileID = fileID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/User_CoverImg_Upd";
}

- (id)requestArgument {
    return @{@"FileID":@(_fileID)};
}

@end
