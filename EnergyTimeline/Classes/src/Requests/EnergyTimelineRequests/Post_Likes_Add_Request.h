//
//  Post_Likes_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 帖子点赞 需登录 */
@interface Post_Likes_Add_Request : ETRequest

- (id)initWithPostID:(NSInteger)postID;

@end
