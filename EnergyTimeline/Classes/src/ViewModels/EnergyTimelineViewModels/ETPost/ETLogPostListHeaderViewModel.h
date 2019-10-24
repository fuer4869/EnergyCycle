//
//  ETLogPostListHeaderViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/11/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETLogPostListHeaderViewModel : ETViewModel

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshSubject;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
