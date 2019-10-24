//
//  ETSignRankListViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETSignRankHeaderViewModel.h"

@interface ETSignRankListViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *myCheckInCommand;

@property (nonatomic, strong) RACCommand *likeSignCommand;

@property (nonatomic, strong) ETSignRankHeaderViewModel *headerViewModel;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *likeClickSubject;

@property (nonatomic, strong) RACSubject *headerCellClickSubject;

@end
