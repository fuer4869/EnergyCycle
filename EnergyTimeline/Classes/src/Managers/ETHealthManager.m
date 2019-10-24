//
//  ETHealthManager.m
//  能量圈
//
//  Created by 王斌 on 2017/5/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHealthManager.h"

/** 自动上传步数的后台接口 */
//#import "PK_v4_Report_Add_Request.h"
#import "PK_v3_Report_Add_Request.h"

@implementation ETHealthManager

/** 单例 */
+ (id)sharedInstance {
    static ETHealthManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ETHealthManager alloc] init];
    });
    return manager;
}

/** 判断设备是否支持以及授权HealthKit */
- (void)authorizeHealthKit:(void (^)(BOOL success, NSError *error))completion {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        if (![HKHealthStore isHealthDataAvailable]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"该设备不支持HealthKit" forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain: @"com.raywenderlich.tutorials.healthkit" code:2 userInfo:userInfo];
            if (completion != nil) {
                completion(NO, error);
            }
            return;
        }
        
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError * _Nullable error) {
            if (completion != nil) {
                completion(YES, error);
            }
        }];
        
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"iOS系统低于8.0" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"com.sdqt.healthError" code:0 userInfo:userInfo];
        completion(NO, error);
    }
}

/** 写入权限 */
- (NSSet *)dataTypesToWrite {
    return nil;
//    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//    HKQuantityType *activeEnergyType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
//    return [NSSet setWithObjects:heightType, weightType, temperatureType, activeEnergyType, nil];
}

/** 读取权限 */
- (NSSet *)dataTypesToRead {
//    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//    HKQuantityType *activeEnergyType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    /** 步数 */
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    /** 步行+跑步距离 */
    HKQuantityType *distanceType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//    HKCharacteristicType *birthdayType = [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
//    HKCharacteristicType *sexType = [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    return [NSSet setWithObjects:stepCountType, distanceType, nil];
//    return [NSSet setWithObjects:heightType, weightType, temperatureType, activeEnergyType, stepCountType, distanceType, distanceType, birthdayType, sexType, nil];
}

/** 获取当天的时间段 */
- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:nowDate];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
//    NSDate *startDate = [calendar dateFromComponents:components];
//    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:NSCalendarWrapComponents];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

/** 获取步数 */
- (void)getStepCount:(void (^)(double value, NSError *error))completion {
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepCountType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            completion(NO, error);
        } else {
            NSInteger totalStepCount = 0;
            for (HKQuantitySample *quantitySample in results) {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                totalStepCount += usersHeight;
            }
            NSLog(@"当天行走步数为%ld", (long)totalStepCount);
            completion(totalStepCount, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

/** 获取步行+跑步距离 */
- (void)getDistance:(void (^)(double value, NSError *error))completion {
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescripor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescripor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            completion(NO, error);
        } else {
            double totalDistance = 0;
            for (HKQuantitySample *quantitySample in results) {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totalDistance += usersHeight;
            }
            NSLog(@"当天行走距离为%.2f", totalDistance);
            completion(totalDistance, error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (void)stepAutomaticUpload {
    ETHealthManager *manager = [ETHealthManager sharedInstance];
    [manager authorizeHealthKit:^(BOOL success, NSError *error) {
        if (success) {
            [manager getStepCount:^(double value, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (value > 0) {
//                        PK_v4_Report_Add_Request *reportRequest = [[PK_v4_Report_Add_Request alloc] initWithReport_Items:@[@{@"ProjectID" : @"35", @"ReportNum" : [NSString stringWithFormat:@"%.0f", value]}] PostContent:@"" Is_Sync:ETBOOL(NO) FileIDs:@""];
//                        [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
//                            NSLog(@"%@", request);
//                        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
//                            NSLog(@"%@", request);
//                        }];
                        PK_v3_Report_Add_Request *reportRequest = [[PK_v3_Report_Add_Request alloc] initWithReport_Items:@[@{@"ProjectID" : @"35", @"ReportNum" : [NSString stringWithFormat:@"%.0f", value]}] Is_Sync:ETBOOL(NO) FileIDs:@""];
                        [reportRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
                            NSLog(@"%@", request);
                        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
                            NSLog(@"%@", request);
                        }];
                    }
                });
            }];
        }
    }];
}

#pragma mark -- lazyLoad --

- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

@end
