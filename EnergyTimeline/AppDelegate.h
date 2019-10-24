//
//  AppDelegate.h
//  EnergyTimeline
//
//  Created by Weijie Zhu on 16/8/4.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETTabbarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic)BOOL translateRadioList;

@property (nonatomic, strong) ETTabbarController *tabbarVC;

@end

