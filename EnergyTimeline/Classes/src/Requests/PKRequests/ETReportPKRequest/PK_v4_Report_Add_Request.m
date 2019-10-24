//
//  PK_v4_Report_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_v4_Report_Add_Request.h"

/** 汇报PK项目 可添加文字和图片 */
@implementation PK_v4_Report_Add_Request {
    NSArray *_report_Items;
    NSString *_postContent;
    NSString *_is_Sync;
    NSString *_fileIDs;
}

- (id)initWithReport_Items:(NSArray *)report_Items Is_Sync:(NSString *)is_Sync FileIDs:(NSString *)fileIDs {
    if (self = [super init]) {
        _report_Items = report_Items;
        _is_Sync = is_Sync;
        _fileIDs = fileIDs;
    }
    return self;
}
- (id)initWithReport_Items:(NSArray *)report_Items PostContent:(NSString *)postContent Is_Sync:(NSString *)is_Sync FileIDs:(NSString *)fileIDs {
    if (self = [super init]) {
        _report_Items = report_Items;
        _postContent = postContent ? postContent : @"";
        _is_Sync = is_Sync;
        _fileIDs = fileIDs;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/v4/PK/Report_Add";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (ETRequestSerializerType)requestSerializerType {
    return ETRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{@"Report_Items":_report_Items,
             @"PostContent":_postContent,
             @"Is_Sync":_is_Sync,
             @"FileIDs":_fileIDs};
}

@end
