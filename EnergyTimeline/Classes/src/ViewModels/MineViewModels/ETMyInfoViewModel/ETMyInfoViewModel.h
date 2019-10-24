//
//  ETMyInfoViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETMyInfoTableViewCellViewModel.h"

@interface ETMyInfoViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshUserModelSubject;

@property (nonatomic, strong) RACSubject *editSuccessSubject;

@property (nonatomic, strong) RACCommand *userDataCommand;

@property (nonatomic, strong) RACCommand *editInfoCommand;

@property (nonatomic, strong) ETMyInfoTableViewCellViewModel *infoModel;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *cancelSubject;

@end
