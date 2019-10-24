//
//  ETTrainAudioManager.h
//  能量圈
//
//  Created by 王斌 on 2018/3/12.
//  Copyright © 2018年 王斌. All rights reserved.
//(

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ETTrainBGMFirst = 0,
    ETTrainBGMSecond,
    ETTrainBGMThird,
    ETTrainBGMFourth
} ETTrainBGM;

static NSString * const bgmVolume = @"TRAINBGMVOLUME";
static NSString * const bgmOpen = @"TRAINBGMOPEN";

@interface ETTrainAudioManager : NSObject

/** 训练音频播放器 */
@property (nonatomic, strong) AVQueuePlayer *trainAudioPlayer;
/** 背景音乐播放器 */
@property (nonatomic, strong) AVAudioPlayer *bgmPlayer;
/** 训练音频观察者 */
@property (nonatomic, strong) id timeObser;
/** 当前音频播放时间 */
@property (nonatomic, assign) CGFloat currentTrainPlayTime;
/** 当前音频总时长 */
@property (nonatomic, assign) CGFloat currentTrainTotalTime;
/** 总播放时长(所有队列) */
@property (nonatomic, assign) CGFloat totalTrainPlayTime;
/** 存储背景音乐的数组 */
@property (nonatomic, strong) NSArray *bgmArr;
/** 当前背景音乐 */
@property (nonatomic, assign) ETTrainBGM currentBgm;

/** 训练音频播放器是否正在播放 */
@property (nonatomic, assign) BOOL playing;
/** 背景音乐播放器是否正在播放 */
@property (nonatomic, assign) BOOL bgmPlaying;

/** 单例 */
+ (id)sharedInstance;

- (void)trainEnd;

#pragma mark -- trainAudioPlayer method --

/** 继续训练, 获取播放总时长 */
- (void)continuePlaytime:(CGFloat)time;
/** 开始播放音频 */
- (void)startPlay:(void (^)(AVQueuePlayer * trainAudioPlayer, CMTime time))playTime;
/** 开始/继续播放音频 */
- (void)trainPlay;
/** 暂停播放音频 */
- (void)trainPause;
/** 添加播放列表 */
- (void)appendAudioList:(NSArray *)list;
/** 返回当前播放音频文件名 */
- (NSString *)trainPlayAudioFileName;
/** 返回当前播放音频文件路径 */
- (NSString *)trainPlayAudioFilePath;


#pragma mark -- bgmPlayer method --

/** 播放指定背景音乐 */
- (void)bgmPlayWithBGM:(ETTrainBGM)bgm;
/** 开始/继续播放背景音乐 */
- (void)bgmPlay;
/** 暂停播放背景音乐 */
- (void)bgmPause;
/** 切换上一首背景音乐 */
- (void)bgmPreviousTrack;
/** 切换下一首背景音乐 */
- (void)bgmNextTrack;
/** 背景音乐音量 */
- (CGFloat)bgmVolume;
/** 改变背景音乐音量 */
- (void)bgmVolumeChange:(CGFloat)volume;
/** 背景音乐开关状态 */
- (BOOL)bgmOpen;
/** 背景音乐开启状态改变 */
- (void)bgmOpenChange;
/** 当前背景音乐信息 */
- (NSString *)bgmInfo;


@end
