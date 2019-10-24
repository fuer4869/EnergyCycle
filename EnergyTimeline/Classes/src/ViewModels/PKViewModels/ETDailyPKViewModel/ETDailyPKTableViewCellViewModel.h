//
//  ETDailyPKTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETDailyPKProjectRankListModel.h"

@interface ETDailyPKTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) RACSubject *homePageSubejct;

@property (nonatomic, strong) RACSubject *likeClickSubject;

@property (nonatomic, strong) ETDailyPKProjectRankListModel *model;

@end
