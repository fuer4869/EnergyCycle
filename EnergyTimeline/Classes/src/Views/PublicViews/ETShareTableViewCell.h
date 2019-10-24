//
//  ETShareTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETShareTableViewCellViewModel.h"

@interface ETShareTableViewCell : UITableViewCell

@property (nonatomic, strong) ETShareTableViewCellViewModel *viewModel;

@property (nonatomic, assign) BOOL onTimeline;

@property (nonatomic, assign) BOOL onWechat;

@property (nonatomic, assign) BOOL onWeibo;

@property (nonatomic, assign) BOOL onQQ;

@property (nonatomic, assign) BOOL onQzone;

@end
