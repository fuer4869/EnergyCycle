//
//  ETHomePagePKTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETHomePagePKTableViewCellViewModel.h"

@interface ETHomePagePKTableViewCell : UITableViewCell

@property (nonatomic, strong) ETHomePagePKTableViewCellViewModel *pkViewModel;

@property (nonatomic, strong) ETHomePagePKTableViewCellViewModel *pkRecordViewModel;

@end
