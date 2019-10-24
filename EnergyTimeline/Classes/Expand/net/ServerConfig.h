//
//  ServerConfig.h
//  能量圈
//
//  Created by vj on 2017/3/27.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#ifndef ServerConfig_h
#define ServerConfig_h

static NSString * ETRequestValidationErrorDomains = @"com.energycycles.request.validation";


NS_ENUM(NSInteger) {
    ETRequestValidationErrorInvalidStatusCode = -8,
    ETRequestValidationErrorInvalidJSONFormat = -9,
};

typedef NS_ENUM (NSUInteger, ETAPIManagerRequestType){
    ETAPIManagerRequestTypeGet,                 //get请求
    ETAPIManagerRequestTypePost,                //POST请求
    ETAPIManagerRequestTypePostUpload,             //POST上传文件请求
    ETAPIManagerRequestTypeGETDownload             //下载文件请求，不做返回值解析
};

typedef NS_ENUM(NSInteger, ETRequestMethod) {
    ETRequestMethodGET = 0,
    ETRequestMethodPOST,
    ETRequestMethodHEAD,
    ETRequestMethodPUT,
    ETRequestMethodDELETE,
    ETRequestMethodPATCH,
};

// 请求优先级
typedef NS_ENUM(NSInteger, ETRequestPriority) {
    ETRequestPriorityLow = -4L,
    ETRequestPriorityDefault = 0,
    ETRequestPriorityHigh = 4,
};
    

typedef NS_ENUM(NSInteger, ETResponseSerializerType) {
    
    ETResponseSerializerTypeHTTP,               /// NSData 类型
    
    ETResponseSerializerTypeJSON,               /// JSON object 类型
    
    ETResponseSerializerTypeXMLParser,          /// NSXMLParser 类型
};

typedef NS_ENUM(NSInteger, ETRequestSerializerType) {
    ETRequestSerializerTypeHTTP = 0,
    ETRequestSerializerTypeJSON,
};


typedef void (^ProgressBlock)(NSProgress *taskProgress);
typedef void (^CompletionDataBlock)(id data, NSError *error);
typedef void (^ErrorAlertSelectIndexBlock)(NSUInteger buttonIndex);

#endif /* ServerConfig_h */
