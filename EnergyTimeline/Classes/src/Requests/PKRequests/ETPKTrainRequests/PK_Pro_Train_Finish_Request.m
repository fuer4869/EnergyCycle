//
//  PK_Pro_Train_Finish_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/4/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_Finish_Request.h"

/** 训练完成 */
@implementation PK_Pro_Train_Finish_Request {
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
    return @"ec/Train/Pro_Train_Finish";
}

- (id)requestArgument {
    return @{@"TrainID" : @(_trainID)};
}

@end
