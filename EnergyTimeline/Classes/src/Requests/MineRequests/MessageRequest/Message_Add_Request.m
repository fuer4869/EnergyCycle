//
//  Message_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Message_Add_Request.h"

/** 发消息 */
@implementation Message_Add_Request {
    NSInteger _toUserID;
    NSString *_messageContent;
}

- (id)initWithToUserID:(NSInteger)toUserID MessageContent:(NSString *)messageContent {
    if (self = [super init]) {
        _toUserID = toUserID;
        _messageContent = messageContent;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (NSString *)requestUrl {
    return @"ec/Message/Message_Add";
}

- (id)requestArgument {
    return @{@"ToUserID":@(_toUserID),
             @"MessageContent":_messageContent};
}

@end
