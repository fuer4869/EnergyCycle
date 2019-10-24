//
//  ETRequest.m
//  能量圈
//
//  Created by vj on 2017/3/28.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#import "ETRequest.h"
#import "ETNetworkConfig.h"
#import "ETNetworkUtils.h"

NSString *const ETRequestCacheErrorDomain = @"com.moying.request.cache";

static dispatch_queue_t etrequest_cache_writing_queue(){
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr = DISPATCH_QUEUE_SERIAL;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            attr = dispatch_queue_attr_make_with_qos_class(attr, QOS_CLASS_BACKGROUND, 0);
        }
        queue = dispatch_queue_create("com.moying.etrequest.cache", attr);
    });
    
    return queue;
}

@interface ETCacheSecure : NSObject <NSSecureCoding>
@property (nonatomic, assign) long long version;
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *appVersionString;

@end

@implementation ETCacheSecure

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.version = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(version))] integerValue];
        self.stringEncoding = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(stringEncoding))] integerValue];
        self.creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(creationDate))];
        self.appVersionString = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersionString))];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.version) forKey:NSStringFromSelector(@selector(version))];
    [aCoder encodeObject:@(self.stringEncoding) forKey:NSStringFromSelector(@selector(stringEncoding))];
    [aCoder encodeObject:self.creationDate forKey:NSStringFromSelector(@selector(creationDate))];
    [aCoder encodeObject:self.appVersionString forKey:NSStringFromSelector(@selector(appVersionString))];
}

@end


@interface ETRequest ()

@property (nonatomic)ETCacheSecure * cacheSecure;
@property (nonatomic, strong) NSData *cacheData;
@property (nonatomic, strong) NSString *cacheString;
@property (nonatomic, strong) id cacheJSON;
@property (nonatomic, strong) NSXMLParser *cacheXML;
@property (nonatomic, assign) BOOL dataFromCache;

@end

@implementation ETRequest

- (void)start {
    if (!self.ignoreCache) {
        [self startWithoutCache];
        return;
    }
    
    /// 恢复下载请求
    if (self.resumableDownloadPath) {
        [self startWithoutCache];
        return;
    }
    
    if (![self loadCacheWithError:nil]) {
        [self startWithoutCache];
        return;
    }
    
    // 拿本地缓存
    _dataFromCache = YES;
    /// 直接结束
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestCompletePreprocessor];
        [self requestCompleteFilter];
        ETRequest *strongSelf = self;
        [strongSelf.delegate requestFinished:strongSelf];
        if (strongSelf.successCompletionBlock) {
            strongSelf.successCompletionBlock(strongSelf);
        }
        [strongSelf clearCompletionBlock];
    });
}

- (void)startWithoutCache {
    [self clearCacheVariables];
    [super start];
    
}


#pragma mark - Network Request Delegate

- (void)requestCompletePreprocessor {
    [super requestCompletePreprocessor];
    if (self.writeCacheAsynchronously) {
        dispatch_async(etrequest_cache_writing_queue(), ^{
            [self saveResponseDataToCacheFile:[super responseData]];
        });
    }else {
        [self saveResponseDataToCacheFile:[super responseData]];
    }
}

- (void)requestCompleteFilter {
}

- (void)requestFailedPreprocessor {
}

- (void)requestFailedFilter {
}


#pragma mark - Load Cache





#pragma mark - Subclass Override
- (NSInteger)cacheTimeInSeconds {
    return -1;
}

- (long long)cacheVersion {
    return 0;
}

- (id)cacheSensitiveData {
    return nil;
}

- (BOOL)writeCacheAsynchronously {
    return YES;
}


#pragma mark - Get

- (BOOL)isDataFromCache {
    return _dataFromCache;
}

- (NSData *)responseData {
    if (_cacheData) {
        return _cacheData;
    }
    return [super responseData];
}

- (NSString *)responseString {
    if (_cacheString) {
        return _cacheString;
    }
    return [super responseString];
}

- (id)responseJSONObject {
    if (_cacheJSON) {
        return _cacheJSON;
    }
    return [super responseJSONObject];
}

- (id)responseObject {
    if (_cacheJSON) {
        return _cacheJSON;
    }
    if (_cacheXML) {
        return _cacheXML;
    }
    if (_cacheData) {
        return _cacheData;
    }
    return [super responseObject];
}


#pragma mark - Private 

- (BOOL)loadCacheWithError:(NSError *__autoreleasing *)error {
    if (self.cacheTimeInSeconds < 0) {
        if (error) {
            *error = [NSError errorWithDomain:ETRequestCacheErrorDomain code:ETRequestCacheErrorInvalidCacheTime userInfo:@{ NSLocalizedDescriptionKey:@"缓存已过期或者未找到缓存"}];
            return NO;
        }
    }
    
    if (![self loadCacheSecure]) {
        if (error) {
            *error = [NSError errorWithDomain:ETRequestCacheErrorDomain code:ETRequestCacheErrorInvalidMetadata userInfo:@{ NSLocalizedDescriptionKey:@"数据出错或者缓存不存在"}];
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)validateCacheWithError:(NSError * _Nullable __autoreleasing *)error {
    
    NSDate *creationDate = self.cacheSecure.creationDate;
    NSTimeInterval duration = -[creationDate timeIntervalSinceNow];
    if (duration < 0 || duration > [self cacheTimeInSeconds]) {
        if (error) {
            *error = [NSError errorWithDomain:ETRequestCacheErrorDomain code:ETRequestCacheErrorExpired userInfo:@{NSLocalizedDescriptionKey:@"缓存已过期"}];
        }
        return NO;
    }
    
    long long cacheVersionFileContent = self.cacheSecure.version;
    if (cacheVersionFileContent != [self cacheVersion]) {
        if (error) {
            *error = [NSError errorWithDomain:ETRequestCacheErrorDomain code:ETRequestCacheErrorVersionMismatch userInfo:@{ NSLocalizedDescriptionKey:@"缓存版本不匹配"}];
        }
        return NO;
    }
    
    
    NSString *appVersionString = self.cacheSecure.appVersionString;
    NSString *currentAppVersionString = [ETNetworkUtils appVersionString];
    if (appVersionString || currentAppVersionString) {
        if (appVersionString.length != currentAppVersionString.length || ![appVersionString isEqualToString:currentAppVersionString]) {
            if (error) {
                *error = [NSError errorWithDomain:ETRequestCacheErrorDomain code:ETRequestCacheErrorAppVersionMismatch userInfo:@{ NSLocalizedDescriptionKey:@"App版本与缓存数据版本不匹配"}];
            }
            return NO;
        }
    }
    return YES;
}


// 加载 NSSecureCoding数据
- (BOOL)loadCacheSecure {
    NSString *path = [self cacheMetadataFilePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
        @try {
            _cacheSecure = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            return YES;
        } @catch (NSException *exception) {
            ETLog(@"加载元数据失败, 原因 = %@", exception.reason);
        }
    }
    
    return NO;
}

- (void)saveResponseDataToCacheFile:(NSData *)data {
    if ([self cacheTimeInSeconds] > 0 && ![self isDataFromCache]) {
        if (data != nil) {
            @try {
                
                [data writeToFile:[self cacheFilePath] atomically:YES];
                ETLog(@"缓存存储成功，地址 = %@", [self cacheFilePath]);
                ETCacheSecure *metadata = [[ETCacheSecure alloc] init];
                metadata.version = [self cacheVersion];
                metadata.stringEncoding = [ETNetworkUtils stringEncodingWithRequest:self];
                metadata.creationDate = [NSDate date];
                metadata.appVersionString = [ETNetworkUtils appVersionString];
                [NSKeyedArchiver archiveRootObject:metadata toFile:[self cacheMetadataFilePath]];
            } @catch (NSException *exception) {
                ETLog(@"缓存存储失败，原因 = %@", exception.reason);
            }
        }
    }
}

- (NSString*)cacheMetadataFilePath {
    //path + filename
    NSString *cacheMetadataFileName = [NSString stringWithFormat:@"%@.metadata", [self cacheFileName]];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheMetadataFileName];
    return path;
}

- (NSString*)cacheFileName {
    NSString *requestUrl = [self requestUrl];
    NSString *baseUrl = [ETNetworkConfig sharedConfig].baseUrl;
    id argument = [self cacheFileNameFilterForRequestArgument:[self requestArgument]];
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@",(unsigned long)[self requestMethod],baseUrl,requestUrl,argument];
    NSString *fileName = [ETNetworkUtils md5StringFromString:requestInfo];
    return fileName;
}

- (NSString*)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

// 缓存的基础地址
- (NSString*)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"ETLazyRequestCache"];
    // 过滤缓存地址
    NSArray<id<ETCacheDirPathFilterProtocol>> * cacheFilter = [[ETNetworkConfig sharedConfig] cacheDirPathFilters];
    if (cacheFilter.count > 0) {
        for (id<ETCacheDirPathFilterProtocol>f in cacheFilter) {
            path = [f filterCacheDirPath:path withRequest:self];
        }
    }
    /// 创建文件
    [self createDirectoryIfNeeded:path];
    
    return path;
}


- (void)clearCacheVariables {
    _cacheData = nil;
    _cacheString = nil;
    _cacheXML = nil;
    _cacheJSON = nil;
    _cacheSecure = nil;
}

#pragma mark - 创建缓存目录

/// 如果该目录不存在就创建该目录
/// 如果路径格式不正确则重新创建
- (void)createDirectoryIfNeeded:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}


- (void)createBaseDirectoryAtPath:(NSString*)path {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        ETLog(@"创建缓存目录失败, error = %@", error);
    } else {
        [ETNetworkUtils addDoNotBackupAttribute:path];
    }
}





@end
