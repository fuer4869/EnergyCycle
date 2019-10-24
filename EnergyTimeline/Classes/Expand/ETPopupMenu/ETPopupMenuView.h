//
//  MenuView.h
//  MenuAnimation
//
//  Created by 王斌 on 2017/4/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETPopupMenuItem.h"
@protocol ETPopupMenuViewDelegate;

@interface ETPopupMenuView : UIView

@property (nonatomic, weak) id<ETPopupMenuViewDelegate> delegate;

+ (instancetype)showWithDelegate:(id)delegate MenuBtn:(UIButton *)menuBtn MenuItems:(NSArray *)menuItemsImage;

@end

@protocol ETPopupMenuViewDelegate <NSObject>

@optional
- (void)popupMenuView:(ETPopupMenuView *)view selectedIndex:(NSInteger)index;

@end
