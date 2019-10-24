//
//  ETRankTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETLikeRankListTableViewCellViewModel.h"
#import "ETSignRankListTableViewCellViewModel.h"
#import "ETIntegralRankTableViewCellViewModel.h"

@interface ETRankTableViewCell : UITableViewCell

@property (nonatomic, strong) ETLikeRankListTableViewCellViewModel *likeRankViewModel;

@property (nonatomic, strong) ETSignRankListTableViewCellViewModel *signRankViewModel;

@property (nonatomic, strong) ETIntegralRankTableViewCellViewModel *integralRankViewModel;

@end
