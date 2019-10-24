//
//  ETRemindListViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "NoticeNotReadModel.h"

@interface ETRemindListViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) NoticeNotReadModel *model;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
