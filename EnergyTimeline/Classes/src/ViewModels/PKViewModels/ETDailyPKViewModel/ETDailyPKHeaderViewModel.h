//
//  ETDailyPKHeaderViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETDailyPKProjectRankListModel.h"

@interface ETDailyPKHeaderViewModel : ETViewModel

@property (nonatomic, strong) ETDailyPKProjectRankListModel *model;

@property (nonatomic, strong) RACSubject *homePageSubject;

@end
