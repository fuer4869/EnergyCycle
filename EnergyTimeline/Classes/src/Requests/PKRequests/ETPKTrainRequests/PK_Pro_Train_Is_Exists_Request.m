//
//  PK_Pro_Train_Is_Exists_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/4/19.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_Is_Exists_Request.h"

/** 查看当前是否有未完成的训练 */
@implementation PK_Pro_Train_Is_Exists_Request

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (NSString *)requestUrl {
    return @"ec/Train/Pro_Train_Is_Exists";
}

@end
