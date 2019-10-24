//
//  Post_Del_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Post_Del_Request.h"

/** 删帖 需登录 */
@implementation Post_Del_Request {
    NSInteger _postID;
}

- (id)initWithPostID:(NSInteger)postID {
    if (self = [super init]) {
        _postID = postID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Post/Post_Del";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"PostID":@(_postID)};
}

@end
