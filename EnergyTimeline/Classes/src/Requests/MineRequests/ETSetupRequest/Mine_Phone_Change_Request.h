//
//  Mine_Phone_Change_Request.h
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRequest.h"

/** 修改/绑定手机号 需登录(注:重新登录) */
@interface Mine_Phone_Change_Request : ETRequest

- (id)initWithPhoneNo:(NSString *)phoneNo Code:(NSInteger)code;

@end
