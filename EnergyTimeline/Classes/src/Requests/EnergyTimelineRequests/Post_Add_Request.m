//
//  Post_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Post_Add_Request.h"

/** 新增帖子 */
@implementation Post_Add_Request {
    NSString *_postContent;
    NSInteger _postType;
    NSString *_fileIDs;
    NSString *_toUsers;
    NSInteger _tagID;
}

- (id)initWithPostContent:(NSString *)postContent PostType:(NSInteger)postType FileIDs:(NSString *)fileIDs ToUsers:(NSString *)toUsers TagID:(NSInteger)tagID {
    if (self = [super init]) {
        _postContent = postContent;
        _postType = postType;
        _fileIDs = fileIDs;
        _toUsers = toUsers;
        _tagID = tagID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/v2/Post/Post_Add";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"PostContent":_postContent,
             @"PostType":@(_postType),
             @"FileIDs":_fileIDs,
             @"ToUsers":_toUsers,
             @"TagID":@(_tagID)};
}

@end
