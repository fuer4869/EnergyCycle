//
//  ETUserManager.h
//  能量圈
//
//  Created by 王斌 on 2017/7/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETUserManager : ETViewModel

/** 单例 */
+ (id)sharedInstance;

@property (nonatomic, strong) RACCommand *logoutCommand;

@property (nonatomic, strong) RACSubject *logoutEndSubject;

- (void)logout;

@end
