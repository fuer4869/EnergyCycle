//
//  ETRemindListTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeNotReadModel.h"

@interface ETRemindListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NoticeNotReadModel *model;

@end
