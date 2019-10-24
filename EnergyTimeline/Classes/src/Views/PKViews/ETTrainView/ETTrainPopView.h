//
//  ETTrainPopView.h
//  能量圈
//
//  Created by 王斌 on 2018/3/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETView.h"

@protocol ETTrainPopViewDelegate;

@interface ETTrainPopView : ETView

/** 代理 */
@property (nonatomic, weak) id<ETTrainPopViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title Content:(NSString *)content LeftBtnTitle:(NSString *)leftBtnTitle RightBtnTitle:(NSString *)rightBtnTitle;

- (instancetype)initWithTitle:(NSString *)title ContentArray:(NSArray *)contentArray LeftBtnTitle:(NSString *)leftBtnTitle RightBtnTitle:(NSString *)rightBtnTitle;

@end

@protocol ETTrainPopViewDelegate <NSObject>

@optional

/** 左侧按钮触发方法 */
- (void)leftButtonClick:(NSString *)string;
/** 右侧按钮触发方法 */
- (void)rightButtonClick:(NSString *)string;


@end
