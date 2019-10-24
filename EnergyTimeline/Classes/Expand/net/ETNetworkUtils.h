//
//  ETNetworkUtils.h
//  能量圈
//
//  Created by vj on 2017/4/1.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETBaseRequest.h"


@interface ETNetworkUtils : NSObject


// 数据不备份到iCloud
+ (void)addDoNotBackupAttribute:(NSString *)path;


// 把字符串转成MD5格式
+ (NSString *)md5StringFromString:(NSString *)string;


// app 当前版本
+ (NSString *)appVersionString;


/// 
+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;


+ (BOOL)validateResumeData:(NSData *)data;


+ (NSStringEncoding)stringEncodingWithRequest:(ETBaseRequest *)request;

@end
