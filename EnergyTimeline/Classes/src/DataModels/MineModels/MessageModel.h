//
//  MessageModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MessageModel : JSONModel

/** 消息ID */
@property (nonatomic, strong) NSString<Optional> *MessageID;
/** 发送用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;
/** 接受用户ID */
@property (nonatomic, strong) NSString<Optional> *ToUserID;
/** 消息文本内容 */
@property (nonatomic, strong) NSString<Optional> *MessageContent;
/** 消息发送时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 是否已读 */
@property (nonatomic, strong) NSString<Optional> *Is_Read;
/** 未读消息数 */
@property (nonatomic, strong) NSString<Optional> *NotRead_Num;
/** 发送用户昵称 */
@property (nonatomic, strong) NSString<Optional> *NickName;
/** 发送用户头像 */
@property (nonatomic, strong) NSString<Optional> *ProfilePicture;

@end
