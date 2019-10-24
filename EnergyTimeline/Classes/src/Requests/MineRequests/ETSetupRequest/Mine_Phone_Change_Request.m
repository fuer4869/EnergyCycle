//
//  Mine_Phone_Change_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "Mine_Phone_Change_Request.h"

@implementation Mine_Phone_Change_Request {
    NSString *_phoneNo;
    NSInteger _code;
}

- (id)initWithPhoneNo:(NSString *)phoneNo Code:(NSInteger)code {
    if (self = [super init]) {
        _phoneNo = phoneNo;
        _code = code;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"ec/Account/Phone_Change";
}

- (id)requestArgument {
    return @{@"PhoneNo":_phoneNo,
             @"Code":@(_code)};
}

@end
