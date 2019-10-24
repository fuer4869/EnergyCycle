//
//  Post_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/12.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Post_List_Request.h"

/** 帖子列表 */
@implementation Post_List_Request {
    NSInteger _type;
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSInteger _fromUserID;
    NSString *_searchKey;

}


- (id)initWithType:(ETPostType)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize {
    if (self = [super init]) {
        _type = type;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _fromUserID = 0;
        _searchKey = @"";
    }
    return self;
}

- (id)initWithType:(ETPostType)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize SearchKey:(NSString *)searchKey {
    if (self = [super init]) {
        _type = type;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _fromUserID = 0;
        _searchKey = searchKey;
    }
    return self;
}

- (id)initWithType:(ETPostType)type PageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize FromUserID:(NSInteger)fromUserID {
    if (self = [super init]) {
        _type = type;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
        _fromUserID = fromUserID;
        _searchKey = @"";
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Post/Post_List";
}

- (id)requestArgument {
    return @{@"type":@(_type),
             @"pageIndex":@(_pageIndex),
             @"pageSize":@(_pageSize),
             @"fromUserID":@(_fromUserID),
             @"searchKey":_searchKey};
}

@end
