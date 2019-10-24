//
//  ETNewFansListViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETNewFansListTableViewCellViewModel.h"

@interface ETNewFansListViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *attentionCommand;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *attentionSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
