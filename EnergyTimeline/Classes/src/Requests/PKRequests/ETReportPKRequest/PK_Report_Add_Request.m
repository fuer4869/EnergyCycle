//
//  PK_Report_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Report_Add_Request.h"

/** 汇报PK项目 */
@implementation PK_Report_Add_Request {
    NSInteger _projectID;
    NSInteger _reportNum;
    NSString *_fileIDs;
    NSString *_is_Sync;
}

- (id)initWithProjectID:(NSInteger)projectID ReportNum:(NSInteger)reportNum FileIDs:(NSString *)fileIDs Is_Sync:(NSString *)is_Sync {
    if (self = [super init]) {
        _projectID = projectID;
        _reportNum = reportNum;
        _fileIDs = fileIDs;
        _is_Sync = is_Sync;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/v2/PK/Report_Add";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"ProjectID":@(_projectID),
             @"ReportNum":@(_reportNum),
             @"FileIDs":_fileIDs,
             @"Is_Sync":_is_Sync};
}

@end
