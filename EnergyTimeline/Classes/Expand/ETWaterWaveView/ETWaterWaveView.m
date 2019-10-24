//
//  ETWaterWaveView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/19.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETWaterWaveView.h"

@interface ETWaterWaveView ()

/** 第一波纹绘制层 */
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
/** 第二波纹绘制层 */
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer;
/** 定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;
/** 水波高度 */
@property (nonatomic, assign) CGFloat waterHight;
/** Y轴方向的缩放 */
@property (nonatomic, assign) CGFloat zoomY;
/** X轴方向的平移 */
@property (nonatomic, assign) CGFloat translateX;
/** 绘制层可用的大小 */
@property (nonatomic, assign) CGSize layerSize;

@end

@implementation ETWaterWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layerSize = frame.size;
        self.waveHeight = 5.0;
        self.firstWaveColor = ETMarkYellowColor;
        self.secondWaveColor = [ETMarkYellowColor colorWithAlphaComponent:0.3];
        self.waterHight = self.frame.size.height;
        self.speed = 1.0;
        self.isShowRound = YES;
        self.isShowSingleWave = NO;
        
        [self.layer addSublayer:self.firstWaveLayer];
        [self.layer addSublayer:self.secondWaveLayer];
        
//        [self stopWaveAnimation];
//        [self startWaveAnimation];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    // 可能出现传入的数据超出限制,如果传入的值大于1则为1,小于0则为0
    self.waterHight = self.layerSize.width * (1 - (progress < 0 ? 0 : (progress > 1 ? 1 : progress)));
    
    // 重启动画效果
    [self stopWaveAnimation];
    [self startWaveAnimation];
}

- (void)setIsShowRound:(BOOL)isShowRound {
    _isShowRound = isShowRound;
    self.layer.cornerRadius = self.layerSize.width * (isShowRound ? 0.5 : 0);
    self.layer.masksToBounds = isShowRound;
}

/** 开始波纹动画 */
- (void)startWaveAnimation {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAnimation)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

/** 暂停波纹动画 */
- (void)stopWaveAnimation {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

/** 波纹动画 */
- (void)waveAnimation {
    
    CGFloat waveHeight = self.waveHeight;
    // 如果进度小于或等于零以及大于或等于1的情况,波纹的幅度改为0
    if (self.progress <= 0.0f || self.progress >= 1.0f) {
        waveHeight = 0.f;
    }
    
    self.translateX += self.speed;
    
    // 第一层波纹
    CGMutablePathRef firstPathRef = CGPathCreateMutable();
    CGFloat firstStartOffY = waveHeight * sinf(self.translateX * M_PI * 2 / self.layerSize.width);
    CGFloat firstOrignOffY = 0.0;
    CGPathMoveToPoint(firstPathRef, NULL, 0, firstStartOffY);
    for (CGFloat i = 0.f; i <= self.layerSize.width; i++) {
        firstOrignOffY = waveHeight * sinf(2 * M_PI / self.layerSize.width * i + self.translateX * M_PI * 2 / self.layerSize.width) + self.waterHight;
        CGPathAddLineToPoint(firstPathRef, NULL, i, firstOrignOffY);
    }
    
    CGPathAddLineToPoint(firstPathRef, NULL, self.layerSize.width, firstOrignOffY);
    CGPathAddLineToPoint(firstPathRef, NULL, self.layerSize.width, self.layerSize.height);
    CGPathAddLineToPoint(firstPathRef, NULL, 0, self.layerSize.height);
    CGPathAddLineToPoint(firstPathRef, NULL, 0, firstStartOffY);
    CGPathCloseSubpath(firstPathRef);
    self.firstWaveLayer.path = firstPathRef;
    self.firstWaveLayer.fillColor = self.firstWaveColor.CGColor;
    CGPathRelease(firstPathRef);
    
//    NSLog(@"waveHeight:%f---translateX:%f---firstStartOffY:%f---firstOrignOffY:%f", waveHeight, self.translateX, firstStartOffY, firstOrignOffY);
    
    // 第二层波纹
    if (!self.isShowSingleWave) {
        CGMutablePathRef secondPathRef = CGPathCreateMutable();
        CGFloat secondStartOffY = waveHeight * sinf(self.translateX * M_PI * 2 / self.layerSize.width);
        CGFloat secondOrignOffY = 0.0;
        CGPathMoveToPoint(secondPathRef, NULL, 0, secondStartOffY);
        for (CGFloat i = 0.f; i <= self.layerSize.width; i++) {
            secondOrignOffY = waveHeight * cosf(2 * M_PI / self.layerSize.width * i + self.translateX * M_PI * 2 / self.layerSize.width) + self.waterHight;
            CGPathAddLineToPoint(secondPathRef, NULL, i, secondOrignOffY);
        }
        
        CGPathAddLineToPoint(secondPathRef, NULL, self.layerSize.width, secondOrignOffY);
        CGPathAddLineToPoint(secondPathRef, NULL, self.layerSize.width, self.layerSize.height);
        CGPathAddLineToPoint(secondPathRef, NULL, 0, self.layerSize.height);
        CGPathAddLineToPoint(secondPathRef, NULL, 0, secondStartOffY);
        CGPathCloseSubpath(secondPathRef);
        self.secondWaveLayer.path = secondPathRef;
        self.secondWaveLayer.fillColor = self.secondWaveColor.CGColor;
        
        CGPathRelease(secondPathRef);
    }
    
    // 如果进度为1时停止计时器
    if (self.progress >= 1) {
        [self stopWaveAnimation];
    }
    
}

#pragma mark -- lazyLoad --

- (CAShapeLayer *)firstWaveLayer {
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
//        _firstWaveLayer.frame = self.bounds;
//        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
    }
    return _firstWaveLayer;
}

- (CAShapeLayer *)secondWaveLayer {
    if (!_secondWaveLayer) {
        _secondWaveLayer = [CAShapeLayer layer];
//        _secondWaveLayer.frame = self.bounds;
//        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
    }
    return _secondWaveLayer;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
