//
//  File_Upload_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/5/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/** NS_ASSUME_NONNULL_BEGIN与NS_ASSUME_NONNULL_END之间所有的简单对象都被设为__nonnull */
NS_ASSUME_NONNULL_BEGIN

/** 文件上传 */
@interface File_Upload_Request : NSObject

/** 上传文件(NSData格式) */
+ (void)uploadWithImageData:(NSData *)imageData
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/** 上传图片组(NSArray(UIImage)格式) */
+ (void)uploadWithImageArr:(NSArray *)imageArr
                   success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject))success
                   failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure;

+ (void)uploadWithImageData:(NSData *_Nullable)imageData
                   imageArr:(NSArray *_Nullable)imageArr
                   progress:(nullable void (^)(NSProgress *uploadProgress))progress
                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
