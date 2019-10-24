//
//  ETRankModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETRankModel : JSONModel

/** 用户昵称 */
@property (nonatomic, strong) NSString<Optional> *NickName;
/** 用户头像 */
@property (nonatomic, strong) NSString<Optional> *ProfilePicture;
/** 排名 -- 世界排名 */
@property (nonatomic, strong) NSString<Optional> *Ranking;
/** 排名 -- 好友排名 */
@property (nonatomic, strong) NSString<Optional> *FriendRanking;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

/** 签到ID */
@property (nonatomic, strong) NSString<Optional> *CheckInID;
/** 签到时间 */
@property (nonatomic, strong) NSString<Optional> *CheckInTime;
/** 签到数 */
@property (nonatomic, strong) NSString<Optional> *EarlyDays;

/** 赞数 */
@property (nonatomic, strong) NSString<Optional> *Likes;

/** 是否喜欢 */
@property (nonatomic, strong) NSString<Optional> *Is_Like;

/** 积分 */
@property (nonatomic, strong) NSString<Optional> *Integral;

/*****
 积分相关
 *****/

/** 用户积分 */
@property (nonatomic, strong) NSString<Optional> *AllIntegral;
/** 世界排名状况 正数为上升名次, 负数为下降名次, 0为不升不降 */
@property (nonatomic, strong) NSString<Optional> *World;
/** 好友排名状况 正数为上升名次, 负数为下降名次, 0为不升不降 */
@property (nonatomic, strong) NSString<Optional> *Friend;
/** 世界排名超过的人数 */
@property (nonatomic, strong) NSString<Optional> *WorldExceedNum;
/** 好友排名超过的人数 */
@property (nonatomic, strong) NSString<Optional> *FriendExceedNum;
/** 世界上还差多少分超过上一个人 */
@property (nonatomic, strong) NSString<Optional> *WorldDiffIntegral;
/** 好友上还差多少分超过上一个人 */
@property (nonatomic, strong) NSString<Optional> *FriendDiffIntegral;
/** 好友排名中上一个名次好友的名字 */
@property (nonatomic, strong) NSString<Optional> *PreFriendName;

@end
