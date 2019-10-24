//
//  ETProductExchangeViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETProductExchangeViewModel : ETViewModel

@property (nonatomic, strong) RACSignal *exchangeEnableSignal;

@property (nonatomic, strong) RACCommand *exchangeCommand;

@property (nonatomic, strong) RACSubject *exchangeEndSubject;

@property (nonatomic, strong) RACSubject *exchangeSubject;

@property (nonatomic, assign) NSInteger productID;

@property (nonatomic, copy) NSString *receiver;

@property (nonatomic, copy) NSString *receivePhone;

@property (nonatomic, copy) NSString *receiveAddress;

@end
