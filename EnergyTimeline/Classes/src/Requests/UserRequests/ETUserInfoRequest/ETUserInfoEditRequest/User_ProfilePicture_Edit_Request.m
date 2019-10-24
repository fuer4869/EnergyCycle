//
//  User_ProfilePicture_Edit_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "User_ProfilePicture_Edit_Request.h"

/** 修改用户头像 需登录 */
@implementation User_ProfilePicture_Edit_Request {
    NSInteger _fileID;
}

- (id)initWithFileID:(NSInteger)fileID {
    if (self = [super init]) {
        _fileID = fileID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/User_ProfilePicture_Edit";
}

- (id)requestArgument {
    return @{@"FileID":@(_fileID)};
}

@end
