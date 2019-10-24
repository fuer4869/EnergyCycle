//
//  ShareSDKMananger.h
//  EnergyTimeline
//
//  Created by vj on 2016/12/8.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

#import "ETShareModel.h"

typedef enum SSMPlatfrom {
    SSMPlatfromNone = 0,
    SSMPlatfromWeibo = 1 << 1,
    SSMPlatfromQQ = 1 << 2,
    SSMPlatfromAlipay = 1 << 3,
    SSMPlatfromWeiXin = 1 << 4
}SSMPlatfrom;

@interface ShareSDKManager : NSObject

+ (instancetype)shareInstance;

- (void)setPlatforms:(SSMPlatfrom)platfroms;

- (void)shareWithShareType:(SSDKPlatformType)shareType shareModel:(ETShareModel *)model webImage:(NSString *)webImage result:(void (^)(SSDKResponseState state))result;

@end
