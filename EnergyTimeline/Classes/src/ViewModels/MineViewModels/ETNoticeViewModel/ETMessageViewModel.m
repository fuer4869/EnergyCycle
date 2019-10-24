//
//  ETMessageViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMessageViewModel.h"
#import "MessageModel.h"
#import "Message_List_Request.h"
#import "Message_Add_Request.h"
#import "User_UserInfo_GetByUserID_Request.h"

@interface ETMessageViewModel ()

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSString *toUserProfilePicture;

@property (nonatomic, strong) NSString *userProfilePicture;

@end

@implementation ETMessageViewModel

- (void)et_initialize {
    @weakify(self)
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                MessageModel *model = [[MessageModel alloc] initWithDictionary:dic error:nil];
                model.MessageContent = [[model.MessageContent stringByRemovingPercentEncoding] jk_stringByStrippingHTML];
                [array insertObject:[[JSQMessage alloc] initWithSenderId:model.UserID senderDisplayName:model.NickName date:[NSDate jk_dateWithString:model.CreateTime format:[NSDate jk_ymdHmsFormat]] text:model.MessageContent] atIndex:0];
                
                [self setProfilePictureWith:model];
            }
            [self setProfilePictureImage];
            self.messages = array;
        }
        [self.refreshFirstEndSubject sendNext:nil];
    }];
    
    
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200 && [responseObject[@"Data"] count]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.messages];
            for (NSDictionary *dic in responseObject[@"Data"]) {
                MessageModel *model = [[MessageModel alloc] initWithDictionary:dic error:nil];
                model.MessageContent = [[model.MessageContent stringByRemovingPercentEncoding] jk_stringByStrippingHTML];
                [array insertObject:[[JSQMessage alloc] initWithSenderId:model.UserID senderDisplayName:model.NickName date:[NSDate jk_dateWithString:model.CreateTime format:[NSDate jk_ymdHmsFormat]] text:model.MessageContent] atIndex:0];
                [self setProfilePictureWith:model];
            }
            [self setProfilePictureImage];
            self.messages = array;
        }
        [self.refreshEndSubject sendNext:nil];
    }];
    
    [self.addMessageCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"发送成功%@", responseObject);
        }
    }];
}

- (void)setProfilePictureWith:(MessageModel *)model {
    if ([self.toUserID isEqualToString:model.UserID] && !self.toUserProfilePicture) {
        self.toUserProfilePicture = model.ProfilePicture;
        self.toUserNickName = model.NickName;
    } else if ([User_ID isEqualToString:model.UserID] && !self.userProfilePicture) {
        self.userProfilePicture = model.ProfilePicture;
    }
}

- (void)setProfilePictureImage {
    if (self.toUserProfilePicture) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.toUserProfilePicture] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                [self.avatars setObject:[JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault] forKey:self.toUserID];
            } else {
                [self.avatars setObject:[JSQMessagesAvatarImageFactory avatarImageWithUserInitials:self.toUserNickName backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f] textColor:[UIColor colorWithWhite:0.6f alpha:1.0f] font:[UIFont systemFontOfSize:14.0f] diameter:kJSQMessagesCollectionViewAvatarSizeDefault] forKey:self.toUserID];
            }
            [self.refreshEndSubject sendNext:nil];
        }];
    } else {
        [self.avatars setObject:[JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:ETUserPortrait_Default] diameter:kJSQMessagesCollectionViewAvatarSizeDefault] forKey:self.toUserID];
    }
    
    if (self.userProfilePicture) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.userProfilePicture] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                [self.avatars setObject:[JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:kJSQMessagesCollectionViewAvatarSizeDefault] forKey:User_ID];
            } else {
                [self.avatars setObject:[JSQMessagesAvatarImageFactory avatarImageWithUserInitials:User_ID backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f] textColor:[UIColor colorWithWhite:0.6f alpha:1.0f] font:[UIFont systemFontOfSize:14.0f] diameter:kJSQMessagesCollectionViewAvatarSizeDefault] forKey:User_ID];
            }
            [self.refreshEndSubject sendNext:nil];
        }];
    } else {
        [self.avatars setObject:[JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:ETUserPortrait_Default] diameter:kJSQMessagesCollectionViewAvatarSizeDefault] forKey:User_ID];
    }
}

#pragma mark -- lazyLoad --

- (RACSubject *)refreshEndSubject {
    if (!_refreshEndSubject) {
        _refreshEndSubject = [RACSubject subject];
    }
    return _refreshEndSubject;
}

- (RACSubject *)refreshFirstEndSubject {
    if (!_refreshFirstEndSubject) {
        _refreshFirstEndSubject = [RACSubject subject];
    }
    return _refreshFirstEndSubject;
}

- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self)
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPage = 1;
                Message_List_Request *listRequest = [[Message_List_Request alloc] initWithToUserID:[self.toUserID integerValue] PageIndex:self.currentPage PageSize:10];
                [listRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    if (!_nextPageCommand) {
        @weakify(self)
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                self.currentPage ++;
                Message_List_Request *listRequest = [[Message_List_Request alloc] initWithToUserID:[self.toUserID integerValue] PageIndex:self.currentPage PageSize:10];
                [listRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _nextPageCommand;
}

- (RACCommand *)addMessageCommand {
    if (!_addMessageCommand) {
        @weakify(self)
        _addMessageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *message) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self)
                Message_Add_Request *messageRequest = [[Message_Add_Request alloc] initWithToUserID:[self.toUserID integerValue] MessageContent:message];
                [messageRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                    [subscriber sendNext:request.responseObject];
                    [subscriber sendCompleted];
                } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                    [MBProgressHUD showMessage:@"网络连接失败"];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _addMessageCommand;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

- (NSMutableDictionary *)avatars {
    if (!_avatars) {
        _avatars = [NSMutableDictionary dictionary];
    }
    return _avatars;
}

- (JSQMessagesBubbleImage *)outgoingBubbleImageData {
    if (!_outgoingBubbleImageData) {
//        _outgoingBubbleImageData = [[[JSQMessagesBubbleImageFactory alloc] init] outgoingMessagesBubbleImageWithColor:[ETBlackColor colorWithAlphaComponent:0.08]];
        _outgoingBubbleImageData = [[[JSQMessagesBubbleImageFactory alloc] init] outgoingMessagesBubbleImageWithColor:[[UIColor yellowColor] colorWithAlphaComponent:0.8]];
    }
    return _outgoingBubbleImageData;
}

- (JSQMessagesBubbleImage *)incomingBubbleImageData {
    if (!_incomingBubbleImageData) {
//        _incomingBubbleImageData = [[[JSQMessagesBubbleImageFactory alloc] init] incomingMessagesBubbleImageWithColor:[[ETBlackColor colorWithAlphaComponent:0.08]]];
        _incomingBubbleImageData = [[[JSQMessagesBubbleImageFactory alloc] init] incomingMessagesBubbleImageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.8]];
    }
    return _incomingBubbleImageData;
}

@end
