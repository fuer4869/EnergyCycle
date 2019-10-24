//
//  ETRadioManager.m
//  能量圈
//
//  Created by 王斌 on 2017/6/7.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRadioManager.h"

static NSString * const report_pk = @"report_pk";
static NSString * const report_pk_pool = @"report_pk_pool";
static NSString * const report_post = @"report_post";
static NSString * const checkin = @"checkin";
static NSString * const get_badge = @"get_badge";

@implementation ETRadioManager

+ (id)sharedInstance {
    static ETRadioManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ETRadioManager alloc] init];
    });
    return manager;
}
//
//- (void)addItem:(AFSoundItem *)item {
//    [self.playback initWithItem:item];
//}
//
//- (void)startPlay {
//    [self.playback play];
//}
//- (void)pause {
//    [self.playback pause];
//}
//- (void)startPlay {
//    [self.queue playCurrentItem];
//}
//
//- (void)pause {
//    [self.queue pause];
//}
//
//- (void)playNext {
//    [self.queue playNextItem];
//}
//
//- (void)playPrevious {
//    [self.queue playPreviousItem];
//}
//
//- (void)playItemAtIndex:(NSInteger)index {
//    [self.queue playItemAtIndex:index];
//}

- (void)play {
    [self.player play];
    self.playing = YES;
    [self.clockTime jk_resumeTimer];
    self.status = ETRadioStatusPlaying;
    self.duration = (NSInteger)CMTimeGetSeconds(self.player.currentItem.duration);
}

- (void)pause {
    [self.player pause];
    self.playing = NO;
    [self.clockTime jk_pauseTimer];
    self.status = ETRadioStatusPause;
}

- (void)playUrl:(NSURL *)url {
    if (![self.url isEqual:url]) {
        self.url = url;
        [self playItem:[[AVPlayerItem alloc] initWithURL:self.url]];
    }
    if (self.status == ETRadioStatusPause) {
        [self play];
    }
}

- (void)playUrlWithString:(NSString *)urlString {
    if (![urlString isEqualToString:self.urlString]) {
        self.urlString = urlString;
        self.url = [NSURL URLWithString:urlString];
        [self playItem:[[AVPlayerItem alloc] initWithURL:self.url]];
    }
    if (self.status == ETRadioStatusPause) {
        [self play];
    }
}

- (void)playItem:(AVPlayerItem *)item {
    if (self.player == nil) {
        self.player = [[AVPlayer alloc] initWithPlayerItem:item];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        // 激活音频会话,设置为后台独占播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        // 接收远程控制事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    } else {
        self.totalPlayTime += self.playTime;
        if (self.isClock) {
            [self clockTimeInvalidate];
        }
        [self.player replaceCurrentItemWithPlayerItem:item];
    }
    self.currentItem = item;
    [self play];
    [self timeObserver];
}

- (void)playAudioType:(ETAudioType)audioType {
    NSString *path = @"";
    switch (audioType) {
        case ETAudioTypeReportPK: {
            path = [[NSBundle mainBundle] pathForResource:report_pk ofType:@"mp3"];
        }
            break;
        case ETAudioTypeReportPKPool: {
            path = [[NSBundle mainBundle] pathForResource:report_pk_pool ofType:@"mp3"];
        }
            break;
        case ETAudioTypeReportPost: {
            path = [[NSBundle mainBundle] pathForResource:report_post ofType:@"mp3"];
        }
            break;
        case ETAudioTypeReportCheckIn: {
            path = [[NSBundle mainBundle] pathForResource:checkin ofType:@"mp3"];
        }
            break;
        case ETAudioTypeGetBadge: {
            path = [[NSBundle mainBundle] pathForResource:get_badge ofType:@"mp3"];
        }
            break;
        default:
            break;
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)timeObserver {
    WS(weakSelf)
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.playTime = (NSInteger)CMTimeGetSeconds(time);
        weakSelf.totalTime = (weakSelf.playTime + weakSelf.totalPlayTime) % 60 ? weakSelf.totalTime : (weakSelf.playTime + weakSelf.totalPlayTime) + 60;
    }];
}

- (AVPlayerItem *)getCurrentItem {
    return self.player.currentItem;
}

- (void)clockTimeInterval:(NSTimeInterval)interval {
    self.isClock = YES;
    self.clockTimeDuration = interval;
    WS(weakSelf)
    self.clockTime = [NSTimer jk_scheduledTimerWithTimeInterval:10 block:^{
        if (interval - weakSelf.totalPlayTime - weakSelf.playTime <= 0) {
            [weakSelf pause];
            [weakSelf clockTimeInvalidate];
        }
    } repeats:YES];
}

- (void)clockModel:(RadioClockModel *)clockModel {
    self.isClock = YES;
    self.clockTimeDuration = clockModel.residueTime;
    self.clockModel = clockModel;
    WS(weakSelf)
    self.clockTime = [NSTimer jk_scheduledTimerWithTimeInterval:10 block:^{
        if (self.clockTimeDuration - weakSelf.totalPlayTime - weakSelf.playTime <= 0) {
            [weakSelf pause];
            [weakSelf clockTimeInvalidate];
        }
    } repeats:YES];
}

- (void)clockTimeInvalidate {
    self.isClock = NO;
    [self.clockTime invalidate];
    self.clockModel.isNotification = NO;
    [self.clockModel saveOrUpdate];
}

//- (AFSoundItem *)getCurrentItem {
//    return [self.queue getCurrentItem];
//}
//
//- (NSInteger)indexOfCurrentItem {
//    return [self.queue indexOfCurrentItem];
//}

#pragma mark -- lazyLoad --



@end
