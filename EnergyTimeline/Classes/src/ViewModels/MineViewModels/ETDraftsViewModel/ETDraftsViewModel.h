//
//  ETDraftsViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "DraftsModel.h"

@interface ETDraftsViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *deleteSubject;

@property (nonatomic, strong) RACSubject *resendSubejct;

@property (nonatomic, strong) NSArray *dataArray;


@end
