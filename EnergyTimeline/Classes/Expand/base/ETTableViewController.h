//
//  ETTableViewController.h
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTableViewControllerProtocol.h"

@interface ETTableViewController : UITableViewController <ETTableViewControllerProtocol, UIGestureRecognizerDelegate>

//左边button
- (void)setupLeftNavBarWithTitle:(NSString *)title;
- (void)setupLeftNavBarWithimage:(NSString *)imageName;
- (void)leftAction;

//右边button
- (void)setupRightNavBarWithTitle:(NSString *)title;
- (void)setupRightNavBarWithimage:(NSString *)imageName;
- (void)rightAction;

/** 重置导航栏 */
- (void)resetNavigation;

/** _UIBarBackground */
- (void)navBar_hidden;
- (void)navBar_show;

//动态计算行高
- (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;

@end
