//
//  ETDailyPKProjectRankListModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"
/** 每日PK项目模型 */
@interface ETDailyPKProjectRankListModel : JSONModel

/** 创建时间 */
@property (nonatomic, strong) NSString<Optional> *CreateTime;
/** 项目名称 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 项目图片文件ID */
@property (nonatomic, strong) NSString<Optional> *FileID;
/** 项目图片 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 项目图片_灰色 */
@property (nonatomic, strong) NSString<Optional> *Gray_FilePath;
/** 路径ID */
@property (nonatomic, strong) NSString<Optional> *FileIDs;
/** 当前用户是否喜欢 */
@property (nonatomic, strong) NSString<Optional> *Is_Like;
/** 喜欢数量 */
@property (nonatomic, strong) NSString<Optional> *Likes;
/** PK封面图 */
@property (nonatomic, strong) NSString<Optional> *PKCoverImg;
/** 项目ID */
@property (nonatomic, strong) NSString<Optional> *ProjectID;
/** 项目分类ID */
@property (nonatomic, strong) NSString<Optional> *ProjectTypeID;
/** 排名 */
@property (nonatomic, strong) NSString<Optional> *Ranking;
/** 汇报次数 */
@property (nonatomic, strong) NSString<Optional> *ReportFre;
/** 汇报ID */
@property (nonatomic, strong) NSString<Optional> *ReportID;
/** 汇报数 */
@property (nonatomic, strong) NSString<Optional> *ReportNum;
/** 汇报上限数量 */
@property (nonatomic, strong) NSString<Optional> *Limit;
/** 累计天数 */
@property (nonatomic, strong) NSString<Optional> *Report_Days;
/** 本月累计 */
@property (nonatomic, strong) NSString<Optional> *Report_Num_Month;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;
/** 用户昵称 */
@property (nonatomic, strong) NSString<Optional> *NickName;
/** 用户头像地址 */
@property (nonatomic, strong) NSString<Optional> *ProfilePicture;
/** 项目单位 */
@property (nonatomic, strong) NSString<Optional> *ProjectUnit;
/** 闹钟(提醒)ID 大于0时为有设置提醒 */
@property (nonatomic, strong) NSString<Optional> *ClockID;
/** 是否为有训练功能的项目 */
@property (nonatomic, strong) NSString<Optional> *Is_Train;
/** 是否可以删除 */
@property (nonatomic, strong) NSString<Optional> *Is_CanDel;

@end
