//
//  PK_Pro_Train_Group_Upd_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/4/12.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_Group_Upd_Request.h"

/** 更新每组训练数据 */
@implementation PK_Pro_Train_Group_Upd_Request {
    NSInteger _trainID;
    NSInteger _groupNo;
    NSInteger _duration;
}

- (id)initWithTrainID:(NSInteger)trainID GroupNo:(NSInteger)groupNo Duration:(NSInteger)duration {
    if (self = [super init]) {
        _trainID = trainID;
        _groupNo = groupNo;
        _duration = duration;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Train/Pro_Train_Group_Upd";
}

- (id)requestArgument {
    return @{@"TrainID" : @(_trainID),
             @"GroupNo" : @(_groupNo),
             @"Duration" : @(_duration)};
}

@end
