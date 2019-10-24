//
//  ETInviteCodeViewModel.h
//  能量圈
//
//  Created by 王斌 on 2018/2/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETInviteCodeViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *inviteCodeCommand;

@property (nonatomic, copy) NSString *inviteCode;

@end
