//
//  ETUserTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETSearchUserTableViewCellViewModel.h"
#import "ETNewFansListTableViewCellViewModel.h"
#import "ETAttentionListTableViewCellViewModel.h"
#import "ETFansListTableViewCellViewModel.h"

@interface ETUserTableViewCell : UITableViewCell

@property (nonatomic, strong) ETSearchUserTableViewCellViewModel *searchUserViewModel;

@property (nonatomic, strong) ETNewFansListTableViewCellViewModel *novelFansListViewModel;

@property (nonatomic, strong) ETAttentionListTableViewCellViewModel *attentionListViewModel;

@property (nonatomic, strong) ETFansListTableViewCellViewModel *fansListViewModel;

@end
