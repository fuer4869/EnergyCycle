//
//  ETTrainAudioManager.m
//  能量圈
//
//  Created by 王斌 on 2018/3/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainAudioManager.h"

static NSString * const bgmFirst = @"梦的海洋";
static NSString * const bgmSecond = @"Intro";
static NSString * const bgmThird = @"Battle";
static NSString * const bgmFourth = @"Pacific Rim";

@implementation ETTrainAudioManager

/** 单例 */
+ (id)sharedInstance {
    static ETTrainAudioManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ETTrainAudioManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _bgmArr = @[bgmFirst,
                    bgmSecond,
                    bgmThird,
                    bgmFourth];
        _currentBgm = ETTrainBGMFirst;
    }
    return self;
}

- (void)trainEnd {
    [self trainPause];
    [self bgmPause];
    self.totalTrainPlayTime = 0;
}

#pragma mark -- trainAudioPlayer method --

- (void)continuePlaytime:(CGFloat)time {
    self.totalTrainPlayTime = time;
}

- (void)startPlay:(void (^)(AVQueuePlayer * trainAudioPlayer, CMTime time))playTime {
    
//    AVPlayerItem *item1 = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:backgroundFirst ofType:@"mp3"]]];
//    AVPlayerItem *item2 = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:backgroundSecond ofType:@"mp3"]]];
//    AVPlayerItem *item3 = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:backgroundThird ofType:@"mp3"]]];
////    AVPlayerItem *item4 = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:trainAudio ofType:@"mp3"]]];
//
//
//    //    NSArray *items = @[item2, item3, item4];
//    NSArray *items = @[item2, item3];
//
////    NSArray *items = @[item4];
//
//    self.trainAudioPlayer = [[AVQueuePlayer alloc] initWithItems:items];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trainPlayFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    WS(weakSelf)
    _timeObser = [self.trainAudioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.currentTrainPlayTime = CMTimeGetSeconds(time);
        weakSelf.currentTrainTotalTime = CMTimeGetSeconds(weakSelf.trainAudioPlayer.currentItem.duration);
        weakSelf.totalTrainPlayTime += 0.1;
        playTime(weakSelf.trainAudioPlayer, time);
    }];
    
//    [self trainPlay];

}

- (void)appendAudioList:(NSArray *)list {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *trainAudioPath = [NSString stringWithFormat:@"%@/TrainAudio/", cachesPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtPath:trainAudioPath];
    NSMutableArray *filePathList = [[NSMutableArray alloc] init];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [trainAudioPath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [fileManager attributesOfFileSystemForPath:filePath error:nil];
        NSLog(@"%@", attrs);
        [filePathList addObject:filePath];
    }
    
    
    for (NSInteger i = 0; i < list.count; i++) {
        for (NSString *filePath in filePathList) {
            if ([list[i] isEqualToString:[fileManager displayNameAtPath:filePath]]) {
                AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
                [items addObject:item];
            }
        }
//        NSArray *fileName = [list[i] componentsSeparatedByString:@"."];
//        NSLog(@"%@", [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", fileName[0]] ofType:[NSString stringWithFormat:@"%@", fileName[1]]]);
        
//        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", fileName[0]] ofType:[NSString stringWithFormat:@"%@", fileName[1]]]]];
//        [items addObject:item];
    }
    
    if (self.trainAudioPlayer == nil) {
        // 激活音频会话,设置为后台播放(也可以同时用其他音乐播放器同时播放)
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    
    // 防止之前音频未播放完成移除之前所有资源,
    [self.trainAudioPlayer removeAllItems];
    [self.trainAudioPlayer removeTimeObserver:_timeObser];

    self.trainAudioPlayer = [[AVQueuePlayer alloc] initWithItems:items];
    
}

/** 开始/继续播放音频 */
- (void)trainPlay {
    [self.trainAudioPlayer play];
}

/** 暂停播放音频 */
- (void)trainPause {
    [self.trainAudioPlayer pause];
}

/** 返回当前播放音频文件名 */
- (NSString *)trainPlayAudioFileName {
    NSString *filePath = [self trainPlayAudioFilePath];
    return [[NSFileManager defaultManager] displayNameAtPath:filePath];
}

/** 返回当前播放音频文件路径 */
- (NSString *)trainPlayAudioFilePath {
    AVURLAsset *avAsset = (AVURLAsset *)self.trainAudioPlayer.currentItem.asset;
    NSURL *url = [avAsset URL];
    return [url path];
}

/** 背景音乐播放器 */
- (void)trainPlayFinished:(NSNotification *)sender {
    AVPlayerItem *item = self.trainAudioPlayer.currentItem;
    NSLog(@"%@", item);
    NSLog(@"播放完毕!!!!!!!");
}

#pragma mark -- backgroundPlayer method --

/** 播放指定背景音乐 */
- (void)bgmPlayWithBGM:(ETTrainBGM)bgm {
    NSString *path = @"";
//    switch (bgm) {
//        case ETTrainBGMFirst: {
//            path = [[NSBundle mainBundle] pathForResource:bgmFirst ofType:@"mp3"];
//        }
//            break;
//        case ETTrainBGMSecond: {
//            path = [[NSBundle mainBundle] pathForResource:bgmSecond ofType:@"mp3"];
//        }
//            break;
//        case ETTrainBGMThird: {
//            path = [[NSBundle mainBundle] pathForResource:bgmThird ofType:@"mp3"];
//        }
//            break;
//        default:
//            break;
//    }
    
    path = [[NSBundle mainBundle] pathForResource:self.bgmArr[bgm] ofType:@"mp3"];

    
    self.currentBgm = bgm;
    
    self.bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    // 循环播放
    self.bgmPlayer.numberOfLoops = -1;
    self.bgmPlayer.volume = [self bgmVolume];
    
    
//    self.backgroundPlayer = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:path]];
//    self.backgroundPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    if ([self bgmOpen]) {
        [self bgmPlay];
    } else {
        [self bgmPause];
    }
}

/** 开始/继续播放背景音乐 */
- (void)bgmPlay {
    [self.bgmPlayer play];
    self.bgmPlaying = YES;
}

/** 暂停播放背景音乐 */
- (void)bgmPause {
    [self.bgmPlayer pause];
    self.bgmPlaying = NO;
}

/** 切换上一首背景音乐 */
- (void)bgmPreviousTrack {
    if (self.currentBgm == 0) {
        self.currentBgm = ETTrainBGMFourth;
    } else {
        self.currentBgm -= 1;
    }
    [self bgmPlayWithBGM:self.currentBgm];
}

/** 切换下一首背景音乐 */
- (void)bgmNextTrack {
    if (self.currentBgm == (self.bgmArr.count - 1)) {
        self.currentBgm = ETTrainBGMFirst;
    } else {
        self.currentBgm += 1;
    }
    [self bgmPlayWithBGM:self.currentBgm];
}

/** 背景音乐音量 */
- (CGFloat)bgmVolume {
    // 因为float的默认值为0所以将音量的存储改为string类型
    NSString *volume = [[NSUserDefaults standardUserDefaults] objectForKey:bgmVolume];
    if (volume == nil || [volume isKindOfClass:[NSNull class]] || [volume isEqual:[NSNull null]]) {
        volume = @"1.0";
        [[NSUserDefaults standardUserDefaults] setObject:volume forKey:bgmVolume];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [volume floatValue];
}

/** 改变背景音乐音量 */
- (void)bgmVolumeChange:(CGFloat)volume {
    // 避免传入音量的值超出范围
    if (volume <= 1.0 && volume >= 0.0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", volume] forKey:bgmVolume];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.bgmPlayer.volume = volume;
    }
}

/** 背景音乐开关状态 */
- (BOOL)bgmOpen {
    BOOL open = [[NSUserDefaults standardUserDefaults] boolForKey:bgmOpen];
    return open;
}

/** 背景音乐开启状态改变 */
- (void)bgmOpenChange {
    BOOL open = [[NSUserDefaults standardUserDefaults] boolForKey:bgmOpen];
    open = !open;
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:bgmOpen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (open) {
        [self bgmPlay];
    } else {
        [self bgmPause];
    }
}

/** 当前背景音乐信息 */
- (NSString *)bgmInfo {
    return self.bgmArr[self.currentBgm];
}

#pragma mark -- lazyLoad --

//- (AVAudioPlayer *)trainAudioPlayer {
//    if (!_trainAudioPlayer) {
//        _trainAudioPlayer = [[AVAudioPlayer alloc] init];
//    }
//    return _trainAudioPlayer;
//}

- (NSArray *)bgmArr {
    if (!_bgmArr) {
        _bgmArr = [[NSArray alloc] init];
    }
    return _bgmArr;
}


@end
