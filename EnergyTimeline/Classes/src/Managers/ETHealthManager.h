//
//  ETHealthManager.h
//  能量圈
//
//  Created by 王斌 on 2017/5/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface ETHealthManager : NSObject

@property (nonatomic, strong) HKHealthStore *healthStore;

/** 单例 */
+ (id)sharedInstance;

/** 判断设备是否支持以及授权HealthKit */
- (void)authorizeHealthKit:(void (^)(BOOL success, NSError *error))completion;

/** 获取步数 */
- (void)getStepCount:(void (^)(double value, NSError *error))completion;

/** 获取步行+跑步距离 */
- (void)getDistance:(void (^)(double value, NSError *error))completion;

/** 自动上传步数 */
- (void)stepAutomaticUpload;

@end
