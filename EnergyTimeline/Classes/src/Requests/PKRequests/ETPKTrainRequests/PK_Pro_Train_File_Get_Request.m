//
//  PK_Pro_Train_File_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/4/2.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_File_Get_Request.h"

/** 项目训练音频下载(包括是否包含公用音频文件) */
@implementation PK_Pro_Train_File_Get_Request {
    NSInteger _projectID;
    NSString *_is_HaveCommon;
}

- (id)initWithProjectID:(NSInteger)projectID Is_HaveCommon:(NSString *)is_HaveCommon {
    if (self = [super init]) {
        _projectID = projectID;
        _is_HaveCommon = is_HaveCommon;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Train/Pro_Train_File_Get";
}

- (id)requestArgument {
    return @{@"ProjectID" : @(_projectID),
             @"Is_HaveCommon" : _is_HaveCommon};
}

@end
