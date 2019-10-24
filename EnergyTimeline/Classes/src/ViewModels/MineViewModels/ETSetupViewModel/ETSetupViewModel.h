//
//  ETSetupViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETSetupViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *logoutCommand;

@property (nonatomic, strong) RACSubject *logoutEndSubject;

@property (nonatomic, strong) RACSubject *refreshSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
