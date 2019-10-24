//
//  ETViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@implementation ETViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ETViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        [viewModel et_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {}
    return self;
}

- (void)et_initialize {};



@end
