//
//  Message_Add_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 发消息 */
@interface Message_Add_Request : ETRequest

- (id)initWithToUserID:(NSInteger)toUserID MessageContent:(NSString *)messageContent;

@end
