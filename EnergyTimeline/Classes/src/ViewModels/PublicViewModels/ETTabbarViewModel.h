//
//  ETTabbarViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/7/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETTabbarViewModel : ETViewModel

@property (nonatomic, strong) RACCommand *noticeDataCommand;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *backListTopSubject;

@property (nonatomic, assign) NSInteger noticeNotReadCount;

@end
