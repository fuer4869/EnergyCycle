//
//  ETLoginViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETLoginViewModel : ETViewModel

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) NSString *verificationCode;

@property (nonatomic, strong) RACSignal *validVerificationCodeSignal;

@property (nonatomic, strong) RACSignal *validLoginSignal;

@property (nonatomic, strong) RACCommand *hashCodeCommand;

@property (nonatomic, strong) RACCommand *loginCommand;

@property (nonatomic, strong) RACCommand *verigicationCodeCommand;

@property (nonatomic, strong) RACCommand *thirdLoginCommand;

@end
