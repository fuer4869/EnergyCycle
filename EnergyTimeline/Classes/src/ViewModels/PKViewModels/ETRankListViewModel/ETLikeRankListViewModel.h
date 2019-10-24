//
//  ETLikeRankListViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETLikeRankHeaderViewModel.h"

@interface ETLikeRankListViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *myLikeCommand;

@property (nonatomic, strong) ETLikeRankHeaderViewModel *headerViewModel;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClikeSubject;

@property (nonatomic, strong) RACSubject *headerCellClickSubject;

@end
