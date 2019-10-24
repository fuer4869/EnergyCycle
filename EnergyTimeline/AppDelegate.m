//
//  AppDelegate.m
//  EnergyTimeline
//
//  Created by Weijie Zhu on 16/8/4.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ViewController.h"
#import "ETNavigationController.h"
#import "AFNetworking/AFNetworking.h"
#import "ETNetworkConfig.h"
#import "LoginRequest.h"
#import "ETThirdsManager.h"

#import "ETGuidePageVC.h"

/** 用户管理类 */
#import "ETUserManager.h"

/** 健康数据管理类 */
#import "ETHealthManager.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

/** 将要弃用 */
#import <UserNotifications/UserNotifications.h>
#import "RadioClockModel.h"

static NSString *appKey = @"da84470cd94e0e2dc2db282b";
static NSString *mobClick_appKey = @"5742c4fee0f55ae7910021dd";
static NSString *channel = @"0";
static BOOL isProduction = NO;

@interface AppDelegate () <UNUserNotificationCenterDelegate, JPUSHRegisterDelegate>

@property (nonatomic, strong) ETGuidePageVC *guidePageVC;

@property (nonatomic, strong) ETNavigationController *navigationController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [Chameleon setGlobalThemeUsingPrimaryColor:ETMinorBgColor withSecondaryColor:nil andContentStyle:UIContentStyleContrast];
    
    [Fabric with:@[[Crashlytics class]]];

    [[ETThirdsManager manager] setupThirdsPartyConfigWithApplication:application didFinishLaunchingWithOptions:launchOptions];

    /** 清除角标数量 */
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    /************************* 添加初始化APNs代码  *************************/
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    /************************* 添加初始化JPush代码  *************************/
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    /************************* 注册通知方法 *************************/
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate = self;
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (!error && granted) {
//            NSLog(@"注册通知成功");
//        } else {
//            NSLog(@"注册通知失败");
//        }
//    }];
    
//    //2.1.9版本新增获取registration id block接口。
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        if(resCode == 0){
//            NSLog(@"registrationID获取成功：%@",registrationID);
//        }
//        else{
//            NSLog(@"registrationID获取失败，code：%d",resCode);
//        }
//    }];
    
    /** MobClick 事件统计 */
    UMConfigInstance.appKey = mobClick_appKey;
    UMConfigInstance.channelId = nil; // 默认为App Store
    [MobClick startWithConfigure:UMConfigInstance];
    
    [self setWindow];
    
    [[ETNetworkConfig sharedConfig] setBaseUrl:INTERFACE_URL];
        
    return YES;
}

- (void)setWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSString *save_appVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    
    if (![appVersion isEqualToString:save_appVersion]) {
        self.window.rootViewController = self.guidePageVC;
        User_Logout
    } else {
        self.window.rootViewController = self.navigationController;
    }
    
    [self.window makeKeyAndVisible];
    
}

#pragma mark -- 通知 --

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    
//    NSLog(@"actionIdentifier:%@",response.actionIdentifier);
//    NSLog(@"categoryIdentifier:%@",response.notification.request.content.categoryIdentifier);
//    
//    NSArray * notifications = [RadioClockModel findAll];
//    [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        RadioClockModel*model = [notifications firstObject];
//        model.isNotification = YES;
//        [model saveOrUpdate];
//        if (model) {
//            if ([response.notification.request.content.categoryIdentifier isEqualToString:model.identifier]) {
//                NSLog(@"收到通知%@",response.notification.request.content.categoryIdentifier);
//                self.translateRadioList = YES;
//                [self.tabbarVC setToSelectedIndex:3];
//            }
//        }
//    }];
//    
//    completionHandler();
//}

#pragma mark -- lazyLoad --

- (ETGuidePageVC *)guidePageVC {
    if (!_guidePageVC) {
        _guidePageVC = [[ETGuidePageVC alloc] init];
//        _guidePageVC.pageArray = @[@"guidePage-1", @"guidePage-2", @"guidePage-3", @"guidePage-4"];
//        _guidePageVC.guidePageType = ETGuidePageGif;
        
        _guidePageVC.pageArray = IsiPhoneX ? @[@"guidePage-1_X", @"guidePage-2_X", @"guidePage-3_X"] : @[@"guidePage-1", @"guidePage-2", @"guidePage-3"];
        _guidePageVC.guidePageType = ETGuidePageNormal;
        _guidePageVC.showPageControl = YES;
        @weakify(self)
        [[_guidePageVC.pageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self)
            /** 退出登录 */
            [[ETUserManager sharedInstance] logout];
            
            self.guidePageVC = nil;
            self.window.rootViewController = self.navigationController;
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            // 获取App的版本号
            NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            
            [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"appVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
    return _guidePageVC;
}

- (ETNavigationController *)navigationController {
    if (_navigationController == nil) {
        _navigationController = [[ETNavigationController alloc] initWithRootViewController:self.tabbarVC];
        _navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    return _navigationController;
}

- (ETTabbarController *)tabbarVC {
    if (!_tabbarVC) {
        _tabbarVC = [[ETTabbarController alloc] init];
    }
    return _tabbarVC;
}

#pragma mark -- 注册APNs --

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册成功并上报DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark -- JPUSHRegisterDelegate --

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    /** badge是推送数量, sound是声音, alert是推送内容 */
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    NSLog(@"actionIdentifier:%@",response.actionIdentifier);
    NSLog(@"categoryIdentifier:%@",response.notification.request.content.categoryIdentifier);
    
    NSArray * notifications = [RadioClockModel findAll];
    [notifications enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RadioClockModel*model = [notifications firstObject];
        model.isNotification = YES;
        [model saveOrUpdate];
        if (model) {
            if ([response.notification.request.content.categoryIdentifier isEqualToString:model.identifier]) {
                NSLog(@"收到通知%@",response.notification.request.content.categoryIdentifier);
                self.translateRadioList = YES;
                [self.tabbarVC setToSelectedIndex:3];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RadioTimerPlay" object:model];
            }
        }
    }];
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    NSString *pkSignUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"PKSignUIUpdate"];
//    if (pkSignUpdate) {
//        [[ETHealthManager sharedInstance] stepAutomaticUpload];
//    }
    if (User_Status) {
        [[ETHealthManager sharedInstance] stepAutomaticUpload];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
