//
//  PK_Target_Del_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_Target_Del_Request.h"

@implementation PK_Target_Del_Request {
    NSInteger _targetID;
}

- (id)initWithTargetID:(NSInteger)targetID {
    if (self = [super init]) {
        _targetID = targetID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Target/Target_Del";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"TargetID":@(_targetID)};
}

@end
