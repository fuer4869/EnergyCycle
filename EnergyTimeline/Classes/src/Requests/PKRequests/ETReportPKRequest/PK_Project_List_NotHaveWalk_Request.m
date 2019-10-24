//
//  PK_Project_List_NotHaveWalk_Request.m
//  能量圈
//
//  Created by wb on 2017/9/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Project_List_NotHaveWalk_Request.h"

/** PK项目列表_无健康走 */
@implementation PK_Project_List_NotHaveWalk_Request {
    NSString *_searchKey;
}

- (id)initWithSearchKey:(NSString *)searchKey {
    if (self = [super init]) {
        _searchKey = searchKey;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/Project_List_NotHaveWalk";
}

- (id)requestArgument {
    return @{@"SearchKey" : (_searchKey ? _searchKey : @"")};
}

@end
