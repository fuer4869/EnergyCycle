//
//  ETBadgeRulesViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETBadgeRulesViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger badgeCount;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
