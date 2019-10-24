//
//  ETTrainAudioDownloadView.h
//  能量圈
//
//  Created by 王斌 on 2018/3/27.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETView.h"
#import "ETTrainAudioDownloadViewModel.h"

@protocol ETTrainAudioDownloadViewDelegate;

@interface ETTrainAudioDownloadView : ETView

@property (nonatomic, strong) ETTrainAudioDownloadViewModel *viewModel;

@property (nonatomic, weak) id<ETTrainAudioDownloadViewDelegate> delegate;

@end

@protocol ETTrainAudioDownloadViewDelegate <NSObject>

@optional

/** 下载完成 */
- (void)downloadComplete;

/** 开始训练 */
- (void)startTrain;

@end
