//
//  ETPKProjectRankTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/12/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETPKProjectViewModel.h"

@interface ETPKProjectRankTableViewCell : UITableViewCell

@property (nonatomic, strong) ETDailyPKProjectRankListModel *model;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end
