//
//  ETWaterWaveView.h
//  能量圈
//
//  Created by 王斌 on 2018/3/19.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETWaterWaveView : UIView

/** 进度 0-1 (水波纹占比) */
@property (nonatomic, assign) CGFloat progress;
/** 波纹速度 默认为1 */
@property (nonatomic, assign) CGFloat speed;
/** 波纹幅度 默认为5 */
@property (nonatomic, assign) CGFloat waveHeight;
/** 第一层波纹颜色 */
@property (nonatomic, strong) UIColor *firstWaveColor;
/** 第二层波纹颜色 */
@property (nonatomic, strong) UIColor *secondWaveColor;
/** 是否为圆形 默认为YES */
@property (nonatomic, assign) BOOL isShowRound;
/** 是否显示单层波纹 默认为NO */
@property (nonatomic, assign) BOOL isShowSingleWave;

/** 波纹动画 */
- (void)waveAnimation;

@end
