//
//  ETRestView.h
//  能量圈
//
//  Created by 王斌 on 2018/3/20.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETView.h"

@protocol ETRestViewDelegate;

@interface ETRestView : ETView

@property (nonatomic, assign) NSInteger restTime;

@property (nonatomic, weak) id<ETRestViewDelegate> delegate;

- (instancetype)initWithRestTime:(CGFloat)restTime;

@end

@protocol ETRestViewDelegate <NSObject>

@optional

- (void)restOver;

@end
