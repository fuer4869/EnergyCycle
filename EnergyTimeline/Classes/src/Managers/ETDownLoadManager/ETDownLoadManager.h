//
//  ETDownLoadManager.h
//  能量圈
//
//  Created by 王斌 on 2018/3/8.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ETDownLoadManager : NSObject

//@property (nonatomic, strong) NSProgress *progress;

NS_ASSUME_NONNULL_BEGIN

/** 单例 */
+ (id)sharedInstance;

/** 网络监控 */
- (void)monitoringState:(void (^)(AFNetworkReachabilityStatus status))state;

/** 指定下载链接并开始下载 */
- (void)startDownLoadURL:(NSString *)urlString
                progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress
             destination:(void (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination
       completionHandler:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

NS_ASSUME_NONNULL_END


/** 下载器状态 */
- (NSURLSessionTaskState)downLoadState;

/** 开始/继续下载 */
- (void)startDownLoad;

/** 暂停下载 */
- (void)pauseDownLoad;

/** 停止下载 */
- (void)stopDownLoad;

@end
