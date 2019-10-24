//
//  ETNetworkAgent.h
//  能量圈
//
//  Created by vj on 2017/4/7.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETBaseRequest.h"


@interface ETNetworkAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


+ (ETNetworkAgent*)sharedAgent;


// 添加请求 开始请求数据
- (void)addRequest:(ETBaseRequest*)request;


- (void)removeRequest:(ETBaseRequest*)request;

/// 取消所有请求
- (void)removeAllRequests;


//// 返回一个经过整理的URL
- (NSString *)buildRequestUrl:(ETBaseRequest *)request;


@end
