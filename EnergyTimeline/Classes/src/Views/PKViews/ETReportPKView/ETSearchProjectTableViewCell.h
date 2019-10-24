//
//  ETSearchProjectTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2018/1/5.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETPKProjectModel.h"

typedef enum : NSUInteger {
    ETProjectCellStateTypeNone = 1,
    ETProjectCellStateTypeUnCheck,
    ETProjectCellStateTypeCheck,
} ETProjectCellStateType;

@interface ETSearchProjectTableViewCell : UITableViewCell

@property (nonatomic, strong) ETPKProjectModel *model;

@property (nonatomic, assign) ETProjectCellStateType stateType;

@end
