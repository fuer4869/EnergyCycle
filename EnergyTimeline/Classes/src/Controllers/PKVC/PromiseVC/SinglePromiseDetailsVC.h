//
//  SinglePromiseDetailsVC.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ETViewController.h"
#import "PromiseModel.h"
@interface SinglePromiseDetailsVC : ETViewController

@property (nonatomic, assign) NSInteger targetID;

@property (nonatomic, strong) PromiseModel *model;

@end
