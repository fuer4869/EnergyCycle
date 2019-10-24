//
//  ETBaseRequest.h
//  能量圈
//
//  Created by vj on 2017/3/27.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//  为什么要用_Nonnull  http://stackoverflow.com/questions/32539285/pointer-is-missing-a-nullability-type-specifier

#import <Foundation/Foundation.h>
#import "ServerConfig.h"


@protocol AFMultipartFormData;

typedef void (^ETConstructingBlock)(_Nonnull id<AFMultipartFormData> formData);
typedef void (^ETURLSessionTaskProgressBlock)(NSProgress * _Nonnull);



@class ETBaseRequest;

typedef void(^ETRequestCompletionBlock)(__kindof ETBaseRequest * _Nonnull request);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress * _Nonnull);


@protocol ETRequestDelegate <NSObject>





@optional

///  通过delegate的方式告知请求完成
///
///  @param 参数必须为ETBaseRequest类型.
- (void)requestFinished:(__kindof ETBaseRequest * _Nonnull)request;

///  通过delegate的方式告知请求失败
///
///  @param 参数必须为ETBaseRequest类型.
- (void)requestFailed:(__kindof ETBaseRequest * _Nonnull)request;

@end

@protocol ETRequestAccessory <NSObject>

@optional


- (void)requestWillStart:(id _Nonnull)request;


- (void)requestWillStop:(id _Nonnull)request;


- (void)requestDidStop:(id _Nonnull)request;

@end



@interface ETBaseRequest : NSObject

#pragma mark - Request and Response Information


/// Http请求任务，只有在开始请求的时候才会有值，其余时间都为nil
@property (nonatomic, strong) NSURLSessionTask * _Nonnull requestTask;


@property (nonatomic, strong, readonly) NSURLRequest * _Nonnull currentRequest;


@property (nonatomic, strong, readonly) NSURLRequest * _Nonnull originalRequest;


@property (nonatomic, strong, readonly) NSHTTPURLResponse * _Nonnull response;


@property (nonatomic, readonly) NSInteger responseStatusCode;

// 响应报文的头部 请求失败时为nil
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

// 响应报文Data类型 请求失败时为nil
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;

// 响应报文String类型 请求失败时为nil
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;

// 响应报文 数据类型根据'ETResponseSerializerType'来决定 如果是本地缓存的话将会返回本地的路径URL
@property (nonatomic, strong, readwrite, nullable) id responseObject;

// 响应报文 如果ETResponseSerializerType 为 'ETResponseSerializerTypeJSON' 那么返回的就是该值
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;


@property (nonatomic, strong, readwrite, nullable) NSError *error;

// 任务是否被取消
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;

// 任务是否在执行状态
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;


// 请求的id  初始值为0
@property (nonatomic) NSInteger tag;


@property (nonatomic, strong, nullable) NSDictionary *userInfo;


@property (nonatomic, weak, nullable) id<ETRequestDelegate> delegate;


@property (nonatomic, copy, nullable) ETRequestCompletionBlock successCompletionBlock;


@property (nonatomic, copy, nullable) ETRequestCompletionBlock failureCompletionBlock;

@property (nonatomic, strong, nullable) NSMutableArray<id<ETRequestAccessory>> *requestAccessories;



@property (nonatomic, copy, nullable) ETConstructingBlock constructingBodyBlock;


@property (nonatomic) ETRequestPriority requestPriority;


@property (nonatomic, strong, nullable) NSString *resumableDownloadPath;


@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock resumableDownloadProgressBlock;




- (void)setCompletionBlockWithSuccess:(nullable ETRequestCompletionBlock)success
                              failure:(nullable ETRequestCompletionBlock)failure;


- (void)clearCompletionBlock;



#pragma mark - Request Action
///=============================================================================
/// @name Request Action
///=============================================================================

///  开始请求并且放入请求队列
- (void)start;

///  取消请求并从请求队列中移除
- (void)stop;

///  开始请求的block,使用了这个函数就不用再另外调用start了
- (void)startWithCompletionBlockWithSuccess:(nullable ETRequestCompletionBlock)success
                                    failure:(nullable ETRequestCompletionBlock)failure;

/// 请求超时时间
- (NSTimeInterval)requestTimeoutInterval;



#pragma mark - Subclass Override
/// 请求结束 预处理  在请求结束时线程还没切换到主线程的时候使用的后台线程
- (void)requestCompletePreprocessor;
/// 请求结束 数据处理  意思就是在请求结束后切换到主线程
- (void)requestCompleteFilter;
/// 请求失败 预处理  同‘requestCompletePreprocessor’
- (void)requestFailedPreprocessor;
/// 请求失败 数据处理  同'requestCompleteFilter'
- (void)requestFailedFilter;


- (ETRequestSerializerType)requestSerializerType;


- (ETResponseSerializerType)responseSerializerType;

//域名 服务器地址
- (NSString * _Nonnull)baseUrl;

//接口地址
- (NSString * _Nonnull)requestUrl;

// 接口请求类型 默认Get
- (ETAPIManagerRequestType)requestMethod;


- (nullable NSArray<NSString *> *)requestAuthorizationHeaderFieldArray;


- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;


- (nullable NSURLRequest *)buildCustomUrlRequest;


- (_Nonnull id)cacheFileNameFilterForRequestArgument:(_Nonnull id)argument;


- (nullable id)requestArgument;


- (BOOL)allowsCellularAccess;

// json格式验证器
- (nullable id)jsonValidator;


- (BOOL)statusCodeValidator;


@end
