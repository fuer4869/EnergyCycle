//
//  Post_Likes_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Post_Likes_Add_Request.h"

/** 帖子点赞 需登录 */
@implementation Post_Likes_Add_Request {
    NSInteger _postID;
}

- (id)initWithPostID:(NSInteger)postID {
    if (self = [super init]) {
        _postID = postID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Post/Likes_Add";
}

- (id)requestArgument {
    return @{@"PostID":@(_postID)};
}

@end
