//
//  ETPKProjectAlarmCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2018/1/24.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectAlarmCollectionViewCell.h"

@implementation ETPKProjectAlarmCollectionViewCell

- (void)updateConstraints {
    self.weekLabel.layer.cornerRadius = 8;
    self.weekLabel.layer.masksToBounds = YES;
    
//    [self.weekLabel jk_setRoundedCorners:UIRectCornerAllCorners radius:8];
    
    [super updateConstraints];
}

- (void)setState:(ETPKProjectAlarmState)state {
    if (!state) {
        return;
    }
    
    _state = state;
    
    switch (state) {
        case ETPKProjectAlarmStateUnCheck: {
            self.weekLabel.textColor = ETTextColor_First;
            self.weekLabel.backgroundColor = [ETWhiteColor colorWithAlphaComponent:0.1];
        }
            break;
        
        case ETPKProjectAlarmStateCheck: {
            self.weekLabel.textColor = ETMinorBgColor;
            self.weekLabel.backgroundColor = ETMarkYellowColor;
        }
            break;
            
        case ETPKProjectAlarmStateDisable: {
            self.weekLabel.textColor = ETTextColor_Fourth;
            self.weekLabel.backgroundColor = [ETWhiteColor colorWithAlphaComponent:0.1];
        }
            break;
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
