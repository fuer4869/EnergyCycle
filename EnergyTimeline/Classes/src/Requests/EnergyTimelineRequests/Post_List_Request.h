//
//  Post_List_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/12.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

typedef enum : NSUInteger {
    ETLogPost = 1, // 日志帖子
    ETPKPost, // PK帖子
    ETPromisePost, // 公众承诺
    ETHeroesListPost, // 英雄榜
    ETFollowPost, // 好友帖子
    ETRecommendPost, // 推荐帖子
    ETUserLogPost, // 用户日志帖子
    ETUserPromisePost, // 用户公众承诺帖子
    ETOpinionPost // 吐槽建议帖子
} ETPostType;

/** 帖子列表 */
@interface Post_List_Request : ETRequest

- (id)initWithType:(ETPostType)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize;

- (id)initWithType:(ETPostType)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize SearchKey:(NSString *)searchKey;

- (id)initWithType:(ETPostType)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize FromUserID:(NSInteger)fromUserID;

@end
