//
//  ETNetworkConfig.h
//  能量圈
//
//  Created by vj on 2017/3/31.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ETBaseRequest;
@class AFSecurityPolicy;

@protocol ETUrlFilterProtocol <NSObject>

//
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(ETBaseRequest *)request;

@end

@protocol ETCacheDirPathFilterProtocol <NSObject>

// 在存储数据前先预先存储路径
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(ETBaseRequest *)request;

@end

@interface ETNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)init NS_UNAVAILABLE;



//// 返回一个单列
+ (ETNetworkConfig *)sharedConfig;

@property (nonatomic, strong) NSString *baseUrl;

@property (nonatomic, strong) NSString *cdnUrl;

// 集合了经过筛选的Url
@property (nonatomic, strong, readonly) NSArray<id<ETUrlFilterProtocol>> *urlFilters;

/// 集合了经过筛选的缓存路径
@property (nonatomic, strong, readonly) NSArray<id<ETCacheDirPathFilterProtocol>> *cacheDirPathFilters;


@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;


@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;



- (void)addUrlFilter:(id<ETUrlFilterProtocol>)filter;

- (void)clearUrlFilter;

- (void)addCacheDirPathFilter:(id<ETCacheDirPathFilterProtocol>)filter;

- (void)clearCacheDirPathFilter;

@end
