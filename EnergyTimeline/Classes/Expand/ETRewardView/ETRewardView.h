//
//  ETRewardView.h
//  能量圈
//
//  Created by 王斌 on 2017/7/14.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETRadioManager.h"

@protocol ETRewardViewDelegate;

@interface ETRewardView : UIView

@property (nonatomic, weak) id<ETRewardViewDelegate> delegate;

+ (ETRewardView *)rewardViewWithContent:(NSString *)content;

+ (ETRewardView *)rewardViewWithContent:(NSString *)content duration:(CGFloat)duration;

+ (ETRewardView *)rewardViewWithContent:(NSString *)content duration:(CGFloat)duration audioType:(ETAudioType)audioType;

+ (ETRewardView *)rewardViewWithContent:(NSString *)content extra:(NSString *)extra;

+ (ETRewardView *)rewardViewWithContent:(NSString *)content extra:(NSString *)extra duration:(CGFloat)duration;

+ (ETRewardView *)rewardViewWithContent:(NSString *)content extra:(NSString *)extra duration:(CGFloat)duration audioType:(ETAudioType)audioType;

@end

@protocol ETRewardViewDelegate <NSObject>

@end
