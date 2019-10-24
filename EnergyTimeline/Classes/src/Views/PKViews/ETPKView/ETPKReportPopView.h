//
//  ETPKReportPopView.h
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETView.h"
#import "ETPKReportPopViewModel.h"
#import "ETDailyPKProjectRankListModel.h"

@interface ETPKReportPopView : ETView

@property (nonatomic, strong) ETPKReportPopViewModel *viewModel;

@property (nonatomic, strong) ETDailyPKProjectRankListModel *model;

@end
