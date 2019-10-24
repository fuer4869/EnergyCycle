//
//  ETProductDetailsViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ProductModel.h"
#import "UserModel.h"

@interface ETProductDetailsViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) ProductModel *model;

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) RACSubject *exchangeSubject;

@end
