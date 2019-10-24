//
//  PK_Project_Clock_Add_Request.m
//  能量圈
//
//  Created by 王斌 on 2018/1/25.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "PK_Project_Clock_Add_Request.h"

@implementation PK_Project_Clock_Add_Request {
    NSInteger _clockID;
    NSInteger _projectID;
    NSString *_is_Enabled;
    NSString *_remindTime;
    NSString *_remindDate;
}

- (id)initWithClockID:(NSInteger)clockID ProjectID:(NSInteger)projectID Is_Enabled:(NSString *)is_Enabled RemindTime:(NSString *)remindTime RemindDate:(NSString *)remindDate {
    if (self = [super init]) {
        _clockID = clockID;
        _projectID = projectID;
        _is_Enabled = is_Enabled;
        _remindTime = remindTime;
        _remindDate = remindDate;
    }
    return self;
}

- (ETAPIManagerRequestType)requestMethod {
    return ETAPIManagerRequestTypePost;
}

- (NSString *)requestUrl {
    return @"ec/pk/Project_Clock_Add";
}

- (id)requestArgument {
    return @{@"ClockID" : @(_clockID),
             @"ProjectID" : @(_projectID),
             @"Is_Enabled" : _is_Enabled,
             @"RemindTime" : _remindTime,
             @"RemindDate" : _remindDate};
}

@end
