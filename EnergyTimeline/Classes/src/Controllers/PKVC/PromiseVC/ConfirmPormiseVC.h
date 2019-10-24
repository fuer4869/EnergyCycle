//
//  ConfirmPormiseVC.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ETViewController.h"
//#import "PKSelectedModel.h"
#import "ETPKProjectModel.h"

@interface ConfirmPormiseVC : ETViewController


//@property (nonatomic, strong) PKSelectedModel *model;
@property (nonatomic, strong) ETPKProjectModel *model;
@property (nonatomic, assign) NSInteger promise_number;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end
