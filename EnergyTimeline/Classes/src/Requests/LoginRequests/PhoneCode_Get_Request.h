//
//  PhoneCode_Get_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/4/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 发送手机验证码 */
@interface PhoneCode_Get_Request : ETRequest

//- (id)initWithPhoneNo:(NSString *)phoneNo type:(NSInteger)type;

- (id)initWithPhoneNo:(NSString *)phoneNo type:(NSInteger)type VerificationCode:(NSString *)verificationCode;

@end
