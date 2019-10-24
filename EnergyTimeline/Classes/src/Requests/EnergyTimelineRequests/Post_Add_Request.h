//
//  Post_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 新增帖子 */
@interface Post_Add_Request : ETRequest

- (id)initWithPostContent:(NSString *)postContent PostType:(NSInteger)postType FileIDs:(NSString *)fileIDs ToUsers:(NSString *)toUsers TagID:(NSInteger)tagID;

@end
