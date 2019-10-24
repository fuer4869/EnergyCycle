//
//  File_Upload_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "File_Upload_Request.h"

static NSString * const File_Upload = @"ec/File/File_Upload";

/** 文件上传 */
@implementation File_Upload_Request

+ (void)uploadWithImageData:(NSData *)imageData
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [self uploadWithImageData:imageData imageArr:nil progress:nil success:success failure:failure];
}

+ (void)uploadWithImageArr:(NSArray *)imageArr
                   success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nonnull responseObject))success
                   failure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error))failure {
    [self uploadWithImageData:nil imageArr:imageArr progress:nil success:success failure:failure];
}

+ (void)uploadWithImageData:(NSData *)imageData
                   imageArr:(NSArray *)imageArr
                   progress:(nullable void (^)(NSProgress *uploadProgress))progress
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", @"multipart/form-data", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [manager POST:[NSString stringWithFormat:@"%@/%@", INTERFACE_URL, File_Upload] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData != nil) {
            [formData appendPartWithFileData:imageData name:@"header" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        } else if (imageArr.count) {
            for (NSInteger i = 0; i < imageArr.count; i ++) {
                NSData *data = imageArr[i];
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"photos[%ld]", (long)i] fileName:[NSString stringWithFormat:@"file%ld.jpg", (long)i] mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
}

@end
