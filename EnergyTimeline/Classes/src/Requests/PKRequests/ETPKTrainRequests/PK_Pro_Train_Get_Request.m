//
//  PK_Pro_Train_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/3/30.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_Get_Request.h"

/** 获取训练详情 */
@implementation PK_Pro_Train_Get_Request {
    NSInteger _trainID;
}

- (id)initWithTrainID:(NSInteger)trainID {
    if (self = [super init]) {
        _trainID = trainID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Train/Pro_Train_Get";
}

- (id)requestArgument {
    return @{@"TrainID" : @(_trainID)};
}

@end
