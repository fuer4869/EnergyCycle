//
//  ETDailyPKVC.h
//  能量圈
//
//  Created by 王斌 on 2017/5/14.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ETDailyPKViewModel.h"

@interface ETDailyPKVC : ETViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) ETDailyPKViewModel *viewModel;

@end
