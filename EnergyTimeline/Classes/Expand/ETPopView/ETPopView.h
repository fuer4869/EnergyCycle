//
//  ETPopView.h
//  能量圈
//
//  Created by 王斌 on 2017/4/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETPopViewDelegate;

@interface ETPopView : UIView
/** 阴影层 */
@property (nonatomic, strong) UIButton *shadowView;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *sureBtn;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 点击阴影层关闭事件 */
@property (nonatomic, assign) BOOL shadowClose;

@property (nonatomic, weak) id<ETPopViewDelegate> delegate;

/** 无标题无按钮 */
+ (ETPopView *)popViewWithTip:(NSString *)tip;

- (void)setupSubviewsWithTip:(NSString *)tip;

/** 有标题有关闭按钮 */
+ (ETPopView *)popViewWithTitle:(NSString *)title Tip:(NSString *)tip;

- (void)setupSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip;


/** 有标题有确认和关闭按钮 */
+ (ETPopView *)popViewWithDelegate:(id)delegate Title:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle;

- (void)setupSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle;


/** 有标题有确认和取消按钮 */
+ (ETPopView *)popViewWithDelegate:(id)delegate Title:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle;

- (void)setupSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle;


- (void)setupCustomizeSubviewsWithTitle:(NSString *)title Tip:(NSString *)tip ImageURL:(NSString *)imageUrl WidthScale:(CGFloat)widthScale SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle;

- (void)setupCustomizeSubviewsWithImageURL:(NSString *)imageUrl WidthScale:(CGFloat)widthScale AspectRatio:(CGFloat)aspectRatio SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle;

///** 有标题有确认和取消按钮 */
//+ (ETPopView *)popViewWithDelegate:(id)delegate Title:(NSString *)title Tip:(NSString *)tip SureBtnTitle:(NSString *)sureBtnTitle CancelBtnTitle:(NSString *)cancelBtnTitle;

@end

@protocol ETPopViewDelegate <NSObject>

@optional

/** 确认按钮代理方法 */
- (void)popViewClickSureBtn;

/** 取消按钮代理方法 */
- (void)popViewClickCancelBtn;

/** 点击背景阴影代理方法 */
- (void)popViewClickShadowView;

@end
