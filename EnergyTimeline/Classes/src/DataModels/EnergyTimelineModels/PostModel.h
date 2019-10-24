//
//  PostModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/12.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface PostModel : JSONModel

/** 帖子ID */
@property (nonatomic, strong) NSString<Optional> *PostID;
/** 帖子内容 */
@property (nonatomic, strong) NSString<Optional> *PostContent;
/** 帖子标题 */
@property (nonatomic, strong) NSString<Optional> *PostTitle;
/** 帖子类型 */
@property (nonatomic, strong) NSString<Optional> *PostType;
/** 发帖人ID */
@property (nonatomic, strong) NSString<Optional> *UserID;
/** 发帖人昵称 */
@property (nonatomic, strong) NSString<Optional> *NickName;
/** 发帖人头像地址 */
@property (nonatomic, strong) NSString<Optional> *ProfilePicture;
/** 帖子的第一张图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 标签ID */
@property (nonatomic, strong) NSString<Optional> *TagID;
/** 标签名 */
@property (nonatomic, strong) NSString<Optional> *TagName;
/** 创建时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 阅读量 */
@property (nonatomic, strong) NSString<Optional> *ReadCount;
/** 评论数 */
@property (nonatomic, strong) NSString<Optional> *CommentNum;
/** 点赞数 */
@property (nonatomic, strong) NSString<Optional> *Likes;
/** 是否喜欢 */
@property (nonatomic, strong) NSString<Optional> *Is_Like;
@property (nonatomic, strong) NSString<Optional> *Is_Choice;
@property (nonatomic, strong) NSString<Optional> *Is_Del;

@end
