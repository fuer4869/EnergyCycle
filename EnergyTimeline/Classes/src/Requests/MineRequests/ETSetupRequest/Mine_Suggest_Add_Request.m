//
//  Mine_Suggest_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Mine_Suggest_Add_Request.h"

/** 新增建议 需登录 */
@implementation Mine_Suggest_Add_Request {
    NSString *_suggestContent;
}

- (id)initWithSuggestContent:(NSString *)suggestContent {
    if (self = [super init]) {
        _suggestContent = suggestContent;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/User/Suggest_Add";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"SuggestContent":_suggestContent};
}

@end
