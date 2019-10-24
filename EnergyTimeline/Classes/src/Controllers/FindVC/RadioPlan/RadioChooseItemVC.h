//
//  RadioChooseItemVC.h
//  EnergyCycles
//
//  Created by vj on 2017/1/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ETViewController.h"
#import "RadioClockModel.h"

typedef NS_ENUM(NSUInteger,RadioChooseItemType) {
    RadioChooseItemTypeRadio = 0,
    RadioChooseItemTypeDuration
};

@interface RadioChooseItemVC : ETViewController

- (instancetype)initWithItemType:(RadioChooseItemType)type;

@property (nonatomic,strong)RadioClockModel * model;


@end
