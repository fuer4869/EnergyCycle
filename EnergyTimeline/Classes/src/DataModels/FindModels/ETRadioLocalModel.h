//
//  ETRadioLocalModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/7.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JKDBModel.h"

@interface ETRadioLocalModel : JKDBModel

@property (nonatomic, copy) NSString *radioID;

@property (nonatomic, copy) NSString *radioName;

@property (nonatomic, copy) NSString *radioUrl;

@property (nonatomic, copy) NSString *radioBg;

@property (nonatomic, copy) NSString *radioBgDim;

@property (nonatomic, copy) NSString *radioIcon;

@end
