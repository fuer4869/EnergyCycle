//
//  ProjectVC.h
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ETViewController.h"

@interface ProjectVC : ETViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) RACSubject *projectSubject;

@end
