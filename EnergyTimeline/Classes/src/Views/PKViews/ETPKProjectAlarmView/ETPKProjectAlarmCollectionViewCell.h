//
//  ETPKProjectAlarmCollectionViewCell.h
//  能量圈
//
//  Created by 王斌 on 2018/1/24.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ETPKProjectAlarmStateUnCheck = 1,
    ETPKProjectAlarmStateCheck,
    ETPKProjectAlarmStateDisable
} ETPKProjectAlarmState;

@interface ETPKProjectAlarmCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (nonatomic, assign) ETPKProjectAlarmState state;

@end
