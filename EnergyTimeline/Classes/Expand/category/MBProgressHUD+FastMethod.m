//
//  MBProgressHUD+FastMethod.m
//  能量圈
//
//  Created by 王斌 on 2017/5/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "MBProgressHUD+FastMethod.h"

@implementation MBProgressHUD (FastMethod)

+ (void)show:(NSString *)text mode:(MBProgressHUDMode)mode view:(UIView *)view {
    
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hudView.labelText = text;
    hudView.label.text = text;
    hudView.mode = mode;
    hudView.removeFromSuperViewOnHide = YES;
//    [hudView hide:YES afterDelay:1];
    [hudView hideAnimated:YES afterDelay:1];
    
}

+ (void)showMessage:(NSString *)message {
    [self show:message mode:5 view:nil];
}

@end
