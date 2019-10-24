//
//  ETSuggestViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETSuggestViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *suggestEndSubject;

@property (nonatomic, strong) RACCommand *suggestCommand;

@property (nonatomic, strong) NSString *suggest;

@end
