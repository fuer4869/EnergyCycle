//
//  ThirdsManager.h
//  EnergyTimeline
//
//  Created by vj on 2016/11/10.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

//友盟
#define UM_APPKEY @"5742c4fee0f55ae7910021dd"

// 微信
#define kWechatAppID @"wx583a9239406dfa5f"
#define kWechatAppSecret @"d4624c36b6795d1d99dcf0547af5443d"

// QQ
#define kQQAppID @"1105476106"
#define kQQAppKey @"FtXkR3atEHANB4tG"

// 新浪微博
#define kSinaAppKey @"1576468831"
#define kSinaAppSecret @"22316f7a15b1733d8761c33f8876ba2b"



@interface ETThirdsManager : NSObject

+ (instancetype)manager;

//配置第三方服务
- (void)setupThirdsPartyConfigWithApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;



@end
