//
//  ETUserInfoTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/10/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETUserInfoViewModel.h"

@interface ETUserInfoTableViewCell : UITableViewCell

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) ETUserInfoViewModel *viewModel;

@end
