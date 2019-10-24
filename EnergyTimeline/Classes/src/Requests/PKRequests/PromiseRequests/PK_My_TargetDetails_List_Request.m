//
//  PK_My_TargetDetails_List_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/5/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PK_My_TargetDetails_List_Request.h"

@implementation PK_My_TargetDetails_List_Request {
    NSString *_startDate;
    NSString *_endDate;
}

- (id)initWithStartDate:(NSString *)startDate EndDate:(NSString *)endDate {
    if (self = [super init]) {
        _startDate = startDate;
        _endDate = endDate;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Target/My_TargetDetails_List";
}

- (id)requestArgument {
    return @{@"StartDate":_startDate,
             @"EndDate":_endDate};
}

@end
