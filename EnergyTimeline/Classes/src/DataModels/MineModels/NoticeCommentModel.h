//
//  NoticeCommentModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface NoticeCommentModel : JSONModel

/** 评论内容 */
@property (nonatomic, strong) NSString<Optional> *CommentContent;
/** 创建时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 评论人用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;
/** 评论人昵称 */
@property (nonatomic, strong) NSString<Optional> *NickName;
/** 评论人头像 */
@property (nonatomic, strong) NSString<Optional> *ProfilePicture;
/** 被评论帖子内容 */
@property (nonatomic, strong) NSString<Optional> *PostContent;
/** 被评论帖子内容图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 被评论帖子ID */
@property (nonatomic, strong) NSString<Optional> *PostID;

@end
