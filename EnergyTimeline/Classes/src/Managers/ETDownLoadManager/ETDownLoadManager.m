//
//  ETDownLoadManager.m
//  能量圈
//
//  Created by 王斌 on 2018/3/8.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETDownLoadManager.h"

@interface ETDownLoadManager ()

@property (nonatomic, strong) NSMutableDictionary *urlDic;

@property (nonatomic, strong) NSMutableArray *urlArr;

/** 会话任务下载 */
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/** 链接会话管理器 */
@property (nonatomic, strong) AFURLSessionManager *manager;

@end

@implementation ETDownLoadManager

+ (id)sharedInstance {
    static ETDownLoadManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ETDownLoadManager alloc] init];
    });
    return manager;
}

- (void)monitoring {
    // AFNetWorking中的网络监控管理类
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 开启网络监控
    [manager startMonitoring];
    // 监控管理会监控连接网络的实时状态
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知网络");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"未连接网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"连接蜂窝网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"无限网络");
            }
                break;
            default:
                break;
        }
    }];
}

- (void)monitoringState:(void (^)(AFNetworkReachabilityStatus status))state {
    // 开启网络监控
    [self.manager.reachabilityManager startMonitoring];
    // 监控管理会监控连接网络的实时状态
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        state(status);
    }];
}

- (void)startDownLoadURL:(NSString *)urlString
                progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress
             destination:(void (^)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination
       completionHandler:(void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler {
    
    // 防止链接中包含中文以及特殊字符导致生成url为nil
    NSString *urlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    self.downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress : %qi / %qi", downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        progress(downloadProgress);

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath : %@", targetPath);
        NSLog(@"response : %@", response);
        destination(targetPath, response);
        return [NSFileManager jk_documentsURL];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self.urlArr removeObject:urlString];
        NSLog(@"completionHandler response : %@", response);
        NSLog(@"filePath : %@", filePath);
        NSLog(@"error : %@", error);
        completionHandler(response, filePath, error);
    }];
    
    [self.manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
        NSLog(@"炸了");
    }];
    
    [self.manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        NSLog(@"重定向");
        return nil;
    }];
}

/** 下载器状态 */
- (NSURLSessionTaskState)downLoadState {
    return self.downloadTask.state;
}

/** 开始/继续下载 */
- (void)startDownLoad {
    [self.downloadTask resume];
}

/** 暂停下载 */
- (void)pauseDownLoad {
    [self.downloadTask suspend];
}

/** 停止下载 */
- (void)stopDownLoad {
    [self.downloadTask cancel];
}

#pragma mark -- lazyLoad --

- (AFURLSessionManager *)manager {
    if (!_manager) {
        // 会话配置
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 创建会话管理
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

@end
