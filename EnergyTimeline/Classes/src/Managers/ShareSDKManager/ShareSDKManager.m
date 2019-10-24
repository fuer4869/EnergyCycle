//
//  ShareSDKMananger.m
//  EnergyTimeline
//
//  Created by vj on 2016/12/8.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import "ShareSDKManager.h"

//微信
#define APP_KEY_WEIXIN            @"wx4db0f86a514ef7ef"
#define APP_SECRECT_WEIXIN        @"eb7c123f1794cd3f173569e5bb6801dc"

//QQ
#define APP_ID_QQ                 @"1104987324"
#define APP_KEY_QQ                @"Icfd6jAfqflPmMuL"

//微博
#define APP_KEY_WEIBO             @"4273175200"
#define APP_SECRECT_WEIBO         @"922730ffd03b87285c07c27325146937"
#define APP_KEY_WEIBO_RedirectURL @"http://www.sina.com"


@implementation ShareSDKManager

+ (instancetype)shareInstance {
    static ShareSDKManager *shareNetworkMessage = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareNetworkMessage = [[self alloc] init];
    });
    
    return shareNetworkMessage;
}


- (void)setPlatforms:(SSMPlatfrom)platfroms {
    
    if (platfroms == SSMPlatfromNone || !platfroms) {
        return;
    }
    
    NSMutableArray * platformsArray = [NSMutableArray array];
    
    if (platfroms & SSMPlatfromWeiXin) {
        
        [platformsArray addObject:@(SSDKPlatformTypeWechat)];
    }
    if (platfroms & SSMPlatfromQQ) {
        
        [platformsArray addObject:@(SSDKPlatformTypeQQ)];
    }
    if (platfroms & SSMPlatfromAlipay) {
        
        [platformsArray addObject:@(SSDKPlatformTypeAliPaySocialTimeline)];
    }
    if (platfroms & SSMPlatfromWeibo) {
        
        [platformsArray addObject:@(SSDKPlatformTypeSinaWeibo)];
    }
    
  
    
    [self initialize:platformsArray];
    
}


//注册 微博 微信 qq
//可否做成动态的？


- (void)initialize:(NSMutableArray*)platforms {
    
    
    [ShareSDK registerApp:@"153f499755e1c"
          activePlatforms:platforms
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:APP_KEY_WEIBO
                                           appSecret:APP_SECRECT_WEIBO
                                         redirectUri:APP_KEY_WEIBO_RedirectURL
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:APP_KEY_WEIXIN
                                       appSecret:APP_SECRECT_WEIXIN];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:APP_ID_QQ
                                      appKey:APP_KEY_QQ
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (void)shareWithShareType:(SSDKPlatformType)shareType shareModel:(ETShareModel *)model webImage:(NSString *)webImage result:(void (^)(SSDKResponseState state))result {
    NSMutableDictionary *parameters = [self shareToWeiboWithShareModel:model webImage:webImage];
    [self shareType:shareType parameters:parameters result:^(SSDKResponseState state) {
        result(state);
    }];
}

- (NSMutableDictionary *)shareToWeiboWithShareModel:(ETShareModel *)model webImage:(NSString *)webImage {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters SSDKEnableUseClientShare];
    SSDKContentType contentType = SSDKContentTypeAuto;
    if (model.shareUrl) {
        contentType = SSDKContentTypeWebPage;
    }
    if (webImage) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:webImage]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    [parameters SSDKSetupShareParamsByText:model.content images:image url:[NSURL URLWithString:model.shareUrl]  title:model.title type:contentType];
                                }
                            }];
        return parameters;
    } else {
        if (model.shareUrl) {
            [parameters SSDKSetupShareParamsByText:model.content images:model.imageArray ? model.imageArray : [UIImage imageNamed:ETLogo] url:[NSURL URLWithString:model.shareUrl] title:model.title type:contentType];
        } else {
            [parameters SSDKSetupShareParamsByText:model.content images:model.imageArray ? model.imageArray : [UIImage imageNamed:ETLogo] url:nil title:model.title type:contentType];
        }
        return parameters;
    }
}


- (void)shareType:(SSDKPlatformType)shareType parameters:(NSMutableDictionary *)parameters result:(void (^)(SSDKResponseState state))result {
//    switch (shareType) {
//        case SSDKPlatformSubTypeWechatTimeline: {
//            
//        }
//            break;
//        case SSDKPlatformSubTypeWechatSession: {
//            
//        }
//            break;
//        case SSDKPlatformTypeSinaWeibo: {
//            
//        }
//            break;
//        case SSDKPlatformSubTypeQQFriend: {
//            
//        }
//            break;
//        case SSDKPlatformSubTypeQZone: {
//            
//        }
//            break;
//        default:
//            break;
//    }
    [ShareSDK share:shareType parameters:parameters onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        result(state);
    }];
}



@end
