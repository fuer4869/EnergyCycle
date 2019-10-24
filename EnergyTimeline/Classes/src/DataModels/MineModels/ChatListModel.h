//
//  ChatListModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/22.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ChatListModel : JSONModel

/** 最后一条消息发送时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 是否已读 */
@property (nonatomic, strong) NSString<Optional> *Is_Read;
/** 最后一条聊天记录 */
@property (nonatomic, strong) NSString<Optional> *MessageContent;
/** 消息ID */
@property (nonatomic, strong) NSString<Optional> *MessageID;
/** 联系用户昵称 */
@property (nonatomic, strong) NSString<Optional> *NickName;
/** 未读消息数 */
@property (nonatomic, strong) NSString<Optional> *NotRead_Num;
/** 联系用户头像 */
@property (nonatomic, strong) NSString<Optional> *ProfilePicture;
/** 联系用户的联系对象用户ID(本机用户) */
@property (nonatomic, strong) NSString<Optional> *ToUserID;
/** 联系用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

@end
