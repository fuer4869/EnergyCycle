//
//  ETPromisePostListViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETPromisePostListHeaderViewModel.h"

@interface ETPromisePostListViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *refreshHeaderDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACCommand *postLikeCommand;

@property (nonatomic, strong) ETPromisePostListHeaderViewModel *headerViewModel;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *backListTopSubject;

@property (nonatomic, strong) RACSubject *headerCellClickSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@property (nonatomic, strong) RACSubject *homePageSubject;

@property (nonatomic, strong) RACSubject *postLikeSubject;

@end
