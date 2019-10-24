//
//  NoticeNotReadModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/22.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface NoticeNotReadModel : JSONModel

/** 未读私信 */
@property (nonatomic, strong) NSString<Optional> *Msg;
/** 未读新粉丝 */
@property (nonatomic, strong) NSString<Optional> *NewFriend;
/** 未读通知 */
@property (nonatomic, strong) NSString<Optional> *Notice;
/** 未读帖子评论 */
@property (nonatomic, strong) NSString<Optional> *Post_Commen;
/** 未读帖子喜欢 */
@property (nonatomic, strong) NSString<Optional> *Post_Like;
/** 未读提到我 */
@property (nonatomic, strong) NSString<Optional> *Post_MenTion;

@end
