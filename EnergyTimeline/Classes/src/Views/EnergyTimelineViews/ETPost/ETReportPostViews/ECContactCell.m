//
//  ECContactCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECContactCell.h"

@implementation ECContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}

- (void)setModel:(UserModel *)model {
    _model = model;
    
    self.backgroundColor = ETMinorBgColor;
    self.name.textColor = ETTextColor_Third;
    
    if ([model.isSelected isEqualToString:@"isSelected"]) {
        [self.selectedImg setImage:[UIImage imageNamed:@"select_round_tick_green"]];
    }else {
        [self.selectedImg setImage:[UIImage imageNamed:@"unselected_round_gray"]];
    }
}

@end
