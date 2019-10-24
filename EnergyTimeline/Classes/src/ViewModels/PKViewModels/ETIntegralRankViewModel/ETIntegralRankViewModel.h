//
//  ETIntegralRankViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETRankModel.h"

@interface ETIntegralRankViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *myIntegralDataCommand;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *refreshFriendDataCommand;

@property (nonatomic, strong) RACCommand *nextFriendPageCommand;

@property (nonatomic, strong) RACSubject *refreshScrollSubject;

@property (nonatomic, strong) NSArray *worldDataArray;

@property (nonatomic, strong) NSArray *friendDataArray;

@property (nonatomic, strong) RACSubject *syncSegmentSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *integralRuleSubject;

@property (nonatomic, strong) ETRankModel *model;

@property (nonatomic, assign) NSInteger currentSegment;

@property (nonatomic, assign) BOOL slideBottom;

@end
