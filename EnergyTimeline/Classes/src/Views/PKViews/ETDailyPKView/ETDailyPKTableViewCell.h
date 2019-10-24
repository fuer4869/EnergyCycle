//
//  ETDailyPKTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETDailyPKTableViewCellViewModel.h"

typedef enum : NSUInteger {
    ETDailyPKTableViewCellTypeTop = 1,
    ETDailyPKTableViewCellTypeBottom,
    ETDailyPKTableViewCellTypeDefault,
} ETDailyPKTableViewCellType;

@interface ETDailyPKTableViewCell : UITableViewCell

@property (nonatomic, assign) ETDailyPKTableViewCellType type;

@property (nonatomic, strong) ETDailyPKTableViewCellViewModel *viewModel;

@end
