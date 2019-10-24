//
//  ETNoticeCenterViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/11/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "NoticeNotReadModel.h"

@interface ETNoticeCenterViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *noticeDataCommand;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) NoticeNotReadModel *model;

@end
