//
//  ETSyncPostTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"

@interface ETSyncPostTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) RACSubject *syncSubject;

@end
