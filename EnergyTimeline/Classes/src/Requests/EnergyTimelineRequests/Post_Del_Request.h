//
//  Post_Del_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 删帖 需登录 */
@interface Post_Del_Request : ETRequest

- (id)initWithPostID:(NSInteger)postID;

@end
