//
//  ETPKProjectVC.h
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewController.h"
#import "ETPKProjectViewModel.h"
#import "ZJScrollPageViewDelegate.h"

@interface ETPKProjectVC : ETViewController <ZJScrollPageViewChildVcDelegate>

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end
