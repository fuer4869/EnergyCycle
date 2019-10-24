//
//  PK_Report_Post_Add.m
//  能量圈
//
//  Created by 王斌 on 2017/8/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Report_Post_Add.h"

/** 每日汇总发帖 返回false是没有发帖,返回true是发帖成功 需登录 */
@implementation PK_Report_Post_Add {
    NSString *_postContent;
    NSString *_fileIDs;
}

- (id)initWithPostContent:(NSString *)postContent FileIDs:(NSString *)fileIDs {
    if (self = [super init]) {
        _postContent = postContent ? postContent : @"";
        _fileIDs = fileIDs;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/v3/Post/Report_Post_Add";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"PostContent":_postContent,
             @"FileIDs":_fileIDs};
}


@end
