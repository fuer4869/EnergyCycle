//
//  ETSignRankListTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETRankModel.h"

@interface ETSignRankListTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) ETRankModel *model;

@property (nonatomic, strong) RACSubject *likeClickSubject;

@end
