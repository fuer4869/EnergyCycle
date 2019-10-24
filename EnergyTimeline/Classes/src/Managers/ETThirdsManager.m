//
//  ThirdsManager.m
//  EnergyTimeline
//
//  Created by vj on 2016/11/10.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import "ETThirdsManager.h"
#import "ShareSDKManager.h"


@implementation ETThirdsManager

+ (instancetype)manager
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)setupThirdsPartyConfigWithApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UMConfigInstance.appKey = UM_APPKEY;
    [MobClick startWithConfigure:UMConfigInstance];
    
    [[ShareSDKManager shareInstance] setPlatforms:SSMPlatfromWeiXin|SSMPlatfromWeibo|SSMPlatfromQQ];
//    [[ShareSDKManager shareInstance] setPlatforms:SSMPlatfromWeiXin|SSMPlatfromWeibo];
//    [[ShareSDKManager shareInstance] setPlatforms:SSMPlatfromWeiXin];
    
}

@end
