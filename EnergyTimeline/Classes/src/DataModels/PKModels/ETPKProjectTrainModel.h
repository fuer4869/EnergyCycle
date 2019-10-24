//
//  ETPKProjectTrainModel.h
//  能量圈
//
//  Created by 王斌 on 2018/3/30.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETPKProjectTrainModel : JSONModel

/** 日期 */
@property (nonatomic, strong) NSString<Optional> *AddDate;
/** 时间 */
@property (nonatomic, strong) NSString<Optional> *AddTime;
/** bgm文件ID */
@property (nonatomic, strong) NSString<Optional> *BGMFileID;
/** bgm名 */
@property (nonatomic, strong) NSString<Optional> *BGMFileName;
/** 当前组 */
@property (nonatomic, strong) NSString<Optional> *CurrGroupNo;
/** 持续时间 */
@property (nonatomic, strong) NSString<Optional> *Duration;
/** 训练总组数 */
@property (nonatomic, strong) NSString<Optional> *GroupCount;
/** 每组个数 */
@property (nonatomic, strong) NSString<Optional> *GroupNum;
/** 时间间隔(每次运动之间) */
@property (nonatomic, strong) NSString<Optional> *Interval;
/** 预计时间 */
@property (nonatomic, strong) NSString<Optional> *NeedsTime;
/** 项目图片路径 */
@property (nonatomic, strong) NSString<Optional> *Pro_FilePath;
/** 项目ID */
@property (nonatomic, strong) NSString<Optional> *ProjectID;
/** 项目名称 */
@property (nonatomic, strong) NSString<Optional> *ProjectName;
/** 项目单位 */
@property (nonatomic, strong) NSString<Optional> *ProjectUnit;
/** 休息时间 */
@property (nonatomic, strong) NSString<Optional> *RestInterval;
/** 音源ID(1.海哥 2.熊威 3.尌安) */
@property (nonatomic, strong) NSString<Optional> *SoundType;
/** 训练音频名 */
@property (nonatomic, strong) NSString<Optional> *TrainAudioName;
/** 状态 */
@property (nonatomic, strong) NSString<Optional> *Status;
/** 训练总数 */
@property (nonatomic, strong) NSString<Optional> *TargetNum;
/** 训练ID */
@property (nonatomic, strong) NSString<Optional> *TrainID;
/** 训练个数上限 */
@property (nonatomic, strong) NSString<Optional> *Trainlimit;
/** 用户ID */
@property (nonatomic, strong) NSString<Optional> *UserID;

@end
