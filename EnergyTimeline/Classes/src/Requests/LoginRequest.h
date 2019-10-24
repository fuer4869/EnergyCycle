//
//  LoginRequest.h
//  能量圈
//
//  Created by vj on 2017/4/25.
//  Copyright © 2017年 Weijie Zhu. All rights reserved.
//

#import "ETRequest.h"

@interface LoginRequest : ETRequest

- (id)initWithPhoneNum:(NSString *)phoneNum password:(NSString*)password;

@end
