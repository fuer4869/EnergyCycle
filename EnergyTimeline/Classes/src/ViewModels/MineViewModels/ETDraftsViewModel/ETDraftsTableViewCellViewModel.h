//
//  ETDraftsTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/23.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "DraftsModel.h"

@interface ETDraftsTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) DraftsModel *model;

@property (nonatomic, strong) RACSubject *resendSubject;

@end
