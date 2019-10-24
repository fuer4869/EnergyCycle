//
//  PK_Project_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/2/2.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Project_Add_Request.h"

@implementation PK_Project_Add_Request {
    NSString *_projectName;
    NSString *_projectUnit;
}

- (id)initWithProjectName:(NSString *)projectName projectUnit:(NSString *)projectUnit {
    if (self = [super init]) {
        _projectName = projectName;
        _projectUnit = projectUnit;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/pk/Project_Add";
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (id)requestArgument {
    return @{@"ProjectName" : _projectName,
             @"ProjectUnit" : _projectUnit};
}

@end
