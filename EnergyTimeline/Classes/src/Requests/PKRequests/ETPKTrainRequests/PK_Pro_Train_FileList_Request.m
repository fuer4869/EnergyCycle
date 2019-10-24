//
//  PK_Pro_Train_FileList_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/4/2.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_FileList_Request.h"

/** 项目训练音频列表 */
@implementation PK_Pro_Train_FileList_Request {
    NSInteger _projectID;
}

- (id)initWithProjectID:(NSInteger)projectID {
    if (self = [super init]) {
        _projectID = projectID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Train/Pro_Train_FileList";
}

- (id)requestArgument {
    return @{@"ProjectID" : @(_projectID)};
}

@end
