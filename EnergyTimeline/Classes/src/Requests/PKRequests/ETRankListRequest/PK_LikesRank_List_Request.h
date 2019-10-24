//
//  PK_LikesRank_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** PK点赞排行榜 需登录 */
@interface PK_LikesRank_List_Request : ETRequest

- (id)initWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

@end
