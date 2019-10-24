//
//  ETMyInfoDetailVC.h
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewController.h"
#import "ETMyInfoTableViewCellViewModel.h"

@interface ETMyInfoDetailVC : ETViewController

@property (nonatomic, strong) ETMyInfoTableViewCellViewModel *viewModel;

@property (nonatomic, strong) RACSubject *backSubject;

@end
