//
//  ETMineBadgeViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETBadgeModel.h"

@interface ETMineBadgeViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) NSArray *pkArray;

@property (nonatomic, strong) NSArray *earlyArray;

@property (nonatomic, strong) NSArray *checkInArray;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger badgeCount;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
