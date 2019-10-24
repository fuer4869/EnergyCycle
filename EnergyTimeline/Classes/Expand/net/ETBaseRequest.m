//
//  ETBaseRequest.m
//  能量圈
//
//  Created by vj on 2017/3/27.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#import "ETBaseRequest.h"
#import "ETNetworkPrivate.h"
#import "ETNetworkAgent.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation ETBaseRequest



#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

#pragma mark - Request Configuration


- (void)addAccessory:(id<ETRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}


#pragma mark - Request Configuration

- (void)setCompletionBlockWithSuccess:(ETRequestCompletionBlock)success
                              failure:(ETRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}


- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[ETNetworkAgent sharedAgent] addRequest:self];
    
}

- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[ETNetworkAgent sharedAgent] removeRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}


- (void)startWithCompletionBlockWithSuccess:(ETRequestCompletionBlock)success failure:(ETRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    
    [self start];
}


#pragma mark - Subclass Override

- (void)requestCompletePreprocessor {
}
- (void)requestCompleteFilter {
}
- (void)requestFailedPreprocessor {
}
- (void)requestFailedFilter {
}
- (id)requestArgument {
    return nil;
}
- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

- (ETRequestSerializerType)requestSerializerType {
    return ETRequestSerializerTypeHTTP;
}

- (ETResponseSerializerType)responseSerializerType {
    return ETResponseSerializerTypeJSON;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypeGet;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (NSString*)baseUrl {
    return @"";
}

- (NSString*)requestUrl {
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (BOOL)useCDN {
    return NO;
}

- (BOOL)allowsCellularAccess {
    return YES;
}

- (id)jsonValidator {
    return nil;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, self.currentRequest.URL, self.currentRequest.HTTPMethod, self.requestArgument];
}


@end
