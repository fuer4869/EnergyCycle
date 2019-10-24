//
//  ETPhoneNoChangeViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETPhoneNoChangeViewModel : ETViewModel

//@property (nonatomic, strong) RACSubject *

@property (nonatomic, strong) RACSubject *changeEndSubject;

@property (nonatomic, strong) RACSignal *validVerificationCodeSignal;

@property (nonatomic, strong) RACSignal *validChangeSignal;

@property (nonatomic, strong) RACCommand *hashCodeCommand;

@property (nonatomic, strong) RACCommand *verigicationCodeCommand;

@property (nonatomic, strong) RACCommand *phoneNoChangeCommand;

@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSString *verificationCode;

@end
