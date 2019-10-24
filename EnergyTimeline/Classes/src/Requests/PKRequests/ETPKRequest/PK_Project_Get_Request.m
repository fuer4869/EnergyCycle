//
//  PK_Project_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/3/30.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Project_Get_Request.h"

@implementation PK_Project_Get_Request {
    NSInteger _projectID;
}

- (id)initWithProjectID:(NSInteger)projectID {
    if (self = [super init]) {
        _projectID = projectID;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/PK/Project_Get";
}

- (id)requestArgument {
    return @{@"ProjectID" : @(_projectID)};
}

@end
