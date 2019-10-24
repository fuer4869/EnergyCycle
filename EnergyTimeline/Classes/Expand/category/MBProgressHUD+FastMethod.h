//
//  MBProgressHUD+FastMethod.h
//  能量圈
//
//  Created by 王斌 on 2017/5/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (FastMethod)
/**
 *  UIActivityIndicatorView显示进度 默认值
 *  MBProgressHUDModeIndeterminate
 *  圆形饼图显示进度
 *  MBProgressHUDModeDeterminate
 *  水平进度条显示进度
 *  MBProgressHUDModeDeterminateHorizontalBar
 *  环形进度视图显示进度
 *  MBProgressHUDModeAnnularDeterminate
 *  自定义视图
 *  MBProgressHUDModeCustomView
 *  只显示标签
 *  MBProgressHUDModeText
 *
 */


+ (void)show:(NSString *)text mode:(MBProgressHUDMode)mode view:(UIView *)view;

+ (void)showMessage:(NSString *)message;

@end
