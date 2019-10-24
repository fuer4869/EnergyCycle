//
//  ETSearchRecommendViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETSearchRecommendViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *dismissSubject;

@property (nonatomic, strong) RACCommand *refreshRecommendDataCommand;

@property (nonatomic, strong) RACCommand *refreshPostDataCommand;

@property (nonatomic, strong) RACCommand *nextPostDataCommand;

@property (nonatomic, strong) RACCommand *attentionCommand;

@property (nonatomic, strong) RACCommand *postLikeCommand;

@property (nonatomic, strong) NSArray *recommendDataArray;

@property (nonatomic, strong) NSArray *postDataArray;

@property (nonatomic, strong) RACSubject *shareSubject;

@property (nonatomic, strong) RACSubject *attentionSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *homePageSubject;

@property (nonatomic, strong) RACSubject *postLikeSubject;

@property (nonatomic, strong) RACSubject *userCellClickSubject;

@end
