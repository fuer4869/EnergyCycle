//
//  ETRadioManager.h
//  能量圈
//
//  Created by 王斌 on 2017/6/7.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ETRadioModel.h"
#import "ETRadioLocalModel.h"
#import "RadioClockModel.h"

typedef enum : NSUInteger {
    ETRadioStatusNormal,
    ETRadioStatusReadyToPlay,
    ETRadioStatusPlaying,
    ETRadioStatusPause,
    ETRadioStatusStop,
    ETRadioStatusFailed
} ETRadioStatus;

typedef enum : NSUInteger {
    ETAudioTypeReportPK,
    ETAudioTypeReportPKPool,
    ETAudioTypeReportPost,
    ETAudioTypeReportCheckIn,
    ETAudioTypeGetBadge
} ETAudioType;

@interface ETRadioManager : NSObject

+ (id)sharedInstance;


@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) ETRadioStatus status;

@property (nonatomic, strong) AVPlayerItem *currentItem;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, assign) NSInteger totalPlayTime;

@property (nonatomic, assign) NSInteger totalTime;

@property (nonatomic, assign) NSInteger playTime;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) BOOL playing;

@property (nonatomic, assign) BOOL isClock;

//@property (nonatomic, assign) NSTimeInterval *clockTimeInterval;

@property (nonatomic, strong) NSTimer *clockTime;

@property (nonatomic, assign) NSInteger clockTimeDuration;

@property (nonatomic, strong) RadioClockModel *clockModel;

//@property (nonatomic, strong) dispatch_source_t timer;

//- (void)addItem:(AFSoundItem *)item;
//
//- (void)startPlay;
//
//- (void)pause;
//
//- (void)playNext;
//
//- (void)playPrevious;
//
//- (void)playItemAtIndex:(NSInteger)index;

- (void)play;

- (void)pause;

- (void)playUrl:(NSURL *)url;

- (void)playUrlWithString:(NSString *)urlString;

- (void)playItem:(AVPlayerItem *)item;

- (void)playAudioType:(ETAudioType)audioType;

//- (void)timeObserver:(void (^)(CMTime time))progress;

- (AVPlayerItem *)getCurrentItem;

- (void)clockTimeInterval:(NSTimeInterval)interval;

- (void)clockModel:(RadioClockModel *)clockModel;

//- (void)


//- (AFSoundItem *)getCurrentItem;

//- (NSInteger)indexOfCurrentItem;

@end
