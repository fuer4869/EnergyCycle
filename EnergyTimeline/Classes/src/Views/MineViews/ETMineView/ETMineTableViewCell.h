//
//  ETMineTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/6/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETMineViewModel.h"

@interface ETMineTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) ETMineViewModel *viewModel;

@end
