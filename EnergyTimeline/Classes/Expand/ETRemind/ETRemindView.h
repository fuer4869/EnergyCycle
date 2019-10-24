//
//  ETRemindView.h
//  能量圈
//
//  Created by 王斌 on 2017/11/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETRemindViewDelegate;

@interface ETRemindView : UIView

+ (ETRemindView *)remindImageName:(NSString *)imageName;

+ (ETRemindView *)remindImageArr:(NSMutableArray *)imageArr;

@property (nonatomic, weak) id<ETRemindViewDelegate> delegate;

@end

@protocol ETRemindViewDelegate <NSObject>

@optional

/** 点击背景代理方法 */
- (void)popViewClickRemindView;

@end
