//
//  PK_Pro_Train_End_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/4/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_End_Request.h"

/** 训练结束(中断) */
@implementation PK_Pro_Train_End_Request {
    NSInteger _trainID;
}

- (id)initWithTrainID:(NSInteger)trainID {
    if (self = [super init]) {
        _trainID = trainID;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (NSString *)requestUrl {
    return @"ec/Train/Pro_Train_End";
}

- (id)requestArgument {
    return @{@"TrainID" : @(_trainID)};
}

@end
