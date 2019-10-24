//
//  ETCircleCountDownView.h
//  能量圈
//
//  Created by 王斌 on 2018/3/21.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETCircleCountDownViewDelegate;

@interface ETCircleCountDownView : UIView

/** 倒计时圆环 */
@property (nonatomic, strong) CAShapeLayer *circleLayer;
/** 圆环颜色 */
@property (nonatomic, strong) UIColor *circleColor;
/** 剩余时间 */
@property (nonatomic, strong) UILabel *remainingTime;
/** 现在的时间 */
@property (nonatomic, assign) CGFloat currentTime;
/** 总时间 */
@property (nonatomic, assign) CGFloat totalTime;
/** 代理 */
@property (nonatomic, weak) id<ETCircleCountDownViewDelegate> delegate;

/** 停止动画并重置定时器 */
- (void)stopAnimation;

@end

@protocol ETCircleCountDownViewDelegate <NSObject>

@optional

/** 时间到后执行的代理方法 */
- (void)countDownTimeOut;

@end
