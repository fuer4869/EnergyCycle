//
//  MenuViewItem.h
//  MenuAnimation
//
//  Created by 王斌 on 2017/4/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETPopupMenuItemDelegate;

@interface ETPopupMenuItem : UIImageView

/** 开始位置 */
@property (nonatomic, assign) CGPoint startPoint;
/** 弹出时最远位置 */
@property (nonatomic, assign) CGPoint farPoint;
/** 收起时最远位置 */
@property (nonatomic, assign) CGPoint nearPonint;
/** 弹出后停止位置 */
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, weak) id<ETPopupMenuItemDelegate> delegate;

// 初始化
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                 contentImage:(UIImage *)contentImage
      contentHighlightedImage:(UIImage *)contentHighlightedImage;

@end

@protocol ETPopupMenuItemDelegate <NSObject>

@optional
- (void)popupMenuItemTouchesBegan:(ETPopupMenuItem *)item;

@end
