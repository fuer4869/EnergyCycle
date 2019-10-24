//
//  PhoneCode_Get_Request.m
//  能量圈
//
//  Created by 王斌 on 2017/4/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "PhoneCode_Get_Request.h"

/** 发送手机验证码 */
@implementation PhoneCode_Get_Request {
    NSString *_phoneNo;
    NSInteger _type;
    NSString *_verificationCode;
}

//- (id)initWithPhoneNo:(NSString *)phoneNo type:(NSInteger)type {
//    if (self = [super init]) {
//        _phoneNo = phoneNo;
//        _type = type;
//    }
//    return self;
//}

- (id)initWithPhoneNo:(NSString *)phoneNo type:(NSInteger)type VerificationCode:(NSString *)verificationCode {
    if (self = [super init]) {
        _phoneNo = phoneNo;
        _type = type;
        _verificationCode = verificationCode;
    }
    return self;
}

- (NSString *)requestUrl {
//    return @"ec/Account/PhoneCode_Get";
    return @"ec/Account/SendPhoneVerificationCode";
}

- (id)requestArgument {
//    return @{@"phoneNo":_phoneNo,
//             @"type":@(_type)};
    return @{@"PhoneNo":_phoneNo,
             @"Type":@(_type),
             @"VerificationCode":_verificationCode};
}

@end
