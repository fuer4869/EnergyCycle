//
//  ETRequest.h
//  能量圈
//
//  Created by vj on 2017/3/28.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#import "ETBaseRequest.h"

FOUNDATION_EXPORT NSString *const ETRequestCacheErrorDomain;

NS_ENUM(NSInteger) {
    ETRequestCacheErrorExpired = -1, ///缓存已过期
    ETRequestCacheErrorVersionMismatch = -2, ///缓存版本不匹配
    ETRequestCacheErrorSensitiveDataMismatch = -3,
    ETRequestCacheErrorAppVersionMismatch = -4,
    ETRequestCacheErrorInvalidCacheTime = -5,
    ETRequestCacheErrorInvalidMetadata = -6,
    ETRequestCacheErrorInvalidCacheData = -7,
    };


@interface ETRequest : ETBaseRequest

// 是否忽略缓存
@property (nonatomic) BOOL ignoreCache;

// 加载本地缓存 如果error不为null则说明加载失败
- (BOOL)loadCacheWithError:(NSError * __autoreleasing *)error;

// 如果本地缓存不是最新版本的 可以通过这个接口更新本地缓存
- (void)startWithoutCache;


// 缓存版本
- (long long)cacheVersion;

//
- (void)saveResponseDataToCacheFile:(NSData *)data;

/// 在本地存储的时间 默认为-1 表示还没有存储
- (NSInteger)cacheTimeInSeconds;

/// 异步存储  默认为YES
- (BOOL)writeCacheAsynchronously;




@end
