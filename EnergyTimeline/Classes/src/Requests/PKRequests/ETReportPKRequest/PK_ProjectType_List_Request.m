//
//  PK_ProjectType_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/1/5.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_ProjectType_List_Request.h"

/** PK项目列表(包含项目分类) */
@implementation PK_ProjectType_List_Request {
    NSString *_searchKey;
    NSString *_sort;
}

- (id)initWithSearchKey:(NSString *)searchKey {
    if (self = [super init]) {
        _searchKey = searchKey;
    }
    return self;
}

- (id)initWithSearchKey:(NSString *)searchKey Sort:(NSString *)sort {
    if (self = [super init]) {
        _searchKey = searchKey;
        _sort = sort;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/pk/ProjectType_List";
}

- (id)requestArgument {
    return @{@"SearchKey" : (_searchKey ? _searchKey : @""),
             @"Sort" : (_sort ? _sort : ETBOOL(NO))};
}

@end
