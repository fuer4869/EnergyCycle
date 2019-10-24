//
//  ETMacros.h
//  能量圈
//
//  Created by 王斌 on 2017/5/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#ifndef ETMacros_h
#define ETMacros_h

/** ETHelpManager */

#define User_ID                 [[ETHelpManager sharedInstance] readUserID]
#define User_HashCode           [[ETHelpManager sharedInstance] readHashCode]
#define User_Ticket             [[ETHelpManager sharedInstance] readTicket]
#define User_Role               [[ETHelpManager sharedInstance] readRole]
#define User_NickName           [[ETHelpManager sharedInstance] readNickName]
#define User_Status             [[ETHelpManager sharedInstance] loginStatus]
#define User_Logout             [[ETUserManager sharedInstance] logout];


/// 系统控件默认高度
#define kStatusBarHeight        ([UIScreen mainScreen].bounds.size.height == 812.0 ? 44.0f : 20.f)

#define kTopBarHeight           (44.f)

#define kTabBarHeight           ([UIScreen mainScreen].bounds.size.height == 812.0 ? 83.0f : 49.f)

#define kSafeAreaBottomHeight   ([UIScreen mainScreen].bounds.size.height == 812.0 ? 34.0f : 0)

#define kNavHeight              (kStatusBarHeight + kTopBarHeight)

/** PhoneVersion */

#define IsiPhone4               [([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 960), \
                                [[UIScreen mainScreen] currentMode].size) : \
                                NO)]

#define IsiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 1136), \
                                [[UIScreen mainScreen] currentMode].size) : \
                                NO)

#define IsiPhone6

#define IsiPhoneX               ([UIScreen mainScreen].bounds.size.height == 812 ? YES : NO)

/** Nib Class */
#define NibName(nName)          [UINib nibWithNibName:[NSString stringWithUTF8String:object_getClassName([nName class])] bundle:nil]

#define ClassName(cName)        [NSString stringWithUTF8String:object_getClassName([cName class])]


#endif /* ETMacros_h */
