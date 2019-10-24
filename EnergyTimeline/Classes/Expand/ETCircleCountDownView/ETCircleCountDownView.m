//
//  ETCircleCountDownView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/21.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETCircleCountDownView.h"

#define CIRCLE_ANGLE(angle) ((M_PI * angle) / 180.0)

@interface ETCircleCountDownView ()

/** 计时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;
/** 绘制层可用的大小 */
@property (nonatomic, assign) CGSize layerSize;

@property (nonatomic, assign) NSInteger intervalCount;

@end

@implementation ETCircleCountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layerSize = frame.size;
        self.currentTime = 0.0;
        self.intervalCount = 0;
        self.circleColor = ETMarkYellowColor;
        
        [self.layer addSublayer:self.circleLayer];
        [self addSubview:self.remainingTime];
    }
    return self;
}

- (void)setTotalTime:(CGFloat)totalTime {
    _totalTime = totalTime;
    self.remainingTime.text = [NSString stringWithFormat:@"%.0f", self.totalTime];

    [self stopAnimation];
    [self startAnimation];
}

- (void)startAnimation {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countDownAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopAnimation {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)countDownAnimation {
//    self.currentTime += self.displayLink.duration;
    self.intervalCount ++;
    
    CGPoint centerPoint = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:self.layerSize.width / 2 startAngle:-CIRCLE_ANGLE(90) endAngle:CIRCLE_ANGLE(270) - (M_PI * 2 * (self.intervalCount / 60.0 / self.totalTime)) clockwise:YES];
//        path.lineCapStyle = kCGLineCapRound; // 线条拐角
//        path.lineJoinStyle = kCGLineJoinRound; // 终点处理
    self.circleLayer.path = path.CGPath;
    
    if (self.intervalCount % 60 == 0) {
        self.currentTime ++;
        self.remainingTime.text = [NSString stringWithFormat:@"%.0f", self.totalTime - self.currentTime];
        
        if (self.currentTime >= self.totalTime) {
            [self stopAnimation];
            if ([self.delegate respondsToSelector:@selector(countDownTimeOut)]) {
                [self.delegate countDownTimeOut];
            }
        }
    }
}

#pragma mark -- lazyLoad --

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = self.circleColor.CGColor;
        _circleLayer.lineWidth = 4.0;
        _circleLayer.lineCap = @"round"; // 线条拐角
        _circleLayer.lineJoin = @"round"; // 终点处理
    }
    return _circleLayer;
}

- (UILabel *)remainingTime {
    if (!_remainingTime) {
        _remainingTime = [[UILabel alloc] init];
        _remainingTime.frame = CGRectMake(0, 0, self.layerSize.width, 40);
        _remainingTime.center = CGPointMake(self.layerSize.width / 2, self.layerSize.height / 2);
        _remainingTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:50];
        _remainingTime.textColor = ETMarkYellowColor;
        _remainingTime.textAlignment = NSTextAlignmentCenter;
    }
    return _remainingTime;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
