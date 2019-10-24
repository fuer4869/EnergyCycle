//
//  ETProjectViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/8/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETProjectViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *selectProjectSubject;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) NSArray *dataArray;


@end
