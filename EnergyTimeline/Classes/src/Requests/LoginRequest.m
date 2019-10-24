//
//  LoginRequest.m
//  能量圈
//
//  Created by vj on 2017/4/25.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//


#import "LoginRequest.h"

@implementation LoginRequest {
    NSString *_phoneNum;
    NSString *_password;
    
}

- (id)initWithPhoneNum:(NSString *)phoneNum password:(NSString*)password {
    self = [super init];
    if (self) {
        _phoneNum = phoneNum;
        _password = password;
    }
    return self;
}


- (NSString*)requestUrl {
    return @"/user/Login";
}

- (id)requestArgument {
    return @{@"phoneno":_phoneNum,
             @"password":_password};
}

- (NSInteger)cacheTimeInSeconds {
    return 60 * 3;
}

@end
