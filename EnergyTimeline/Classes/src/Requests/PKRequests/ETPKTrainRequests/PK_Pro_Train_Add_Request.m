//
//  PK_Pro_Train_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/3/30.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Pro_Train_Add_Request.h"

/** 新增训练目标 */
@implementation PK_Pro_Train_Add_Request {
    NSInteger _projectID;
    NSInteger _targetNum;
    NSInteger _soundType;
    NSString *_bgmFileName;
}

- (id)initWithProjectID:(NSInteger)projectID TargetNum:(NSInteger)targetNum SoundType:(NSInteger)soundType BGMFileName:(NSString *)bgmFileName {
    if (self = [super init]) {
        _projectID = projectID;
        _targetNum = targetNum;
        _soundType = soundType;
        _bgmFileName = bgmFileName;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (NSString *)requestUrl {
    return @"ec/Train/Pro_Train_Add";
}

- (id)requestArgument {
    return @{@"ProjectID" : @(_projectID),
             @"TargetNum" : @(_targetNum),
             @"SoundType" : @(_soundType),
             @"BGMFileName" : _bgmFileName};
}

@end
