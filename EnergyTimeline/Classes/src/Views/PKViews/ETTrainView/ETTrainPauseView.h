//
//  ETTrainPauseView.h
//  能量圈
//
//  Created by 王斌 on 2018/3/22.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETView.h"

@protocol ETTrainPauseViewDelegate;

@interface ETTrainPauseView : ETView

/** 代理 */
@property (nonatomic, weak) id<ETTrainPauseViewDelegate> delegate;

@end

@protocol ETTrainPauseViewDelegate <NSObject>

@optional

/** 结束训练 */
- (void)trainOver;
/** 继续训练 */
- (void)trainContinue;

@end
