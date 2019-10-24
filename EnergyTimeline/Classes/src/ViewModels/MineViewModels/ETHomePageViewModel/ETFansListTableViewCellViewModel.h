//
//  ETFansListTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "UserModel.h"

@interface ETFansListTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *attentionSubject;

@property (nonatomic, strong) UserModel *model;

@end
