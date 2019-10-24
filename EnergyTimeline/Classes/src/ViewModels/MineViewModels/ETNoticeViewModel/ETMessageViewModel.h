//
//  ETMessageViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "JSQMessages.h"
#import "UserModel.h"

@interface ETMessageViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshFirstEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *addMessageCommand;

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSMutableDictionary *avatars;

@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (nonatomic, strong) NSDictionary *users;

@property (nonatomic, strong) NSString *toUserNickName;

@property (nonatomic, strong) NSString *toUserID;

@end
