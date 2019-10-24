//
//  ETNoDataTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNoDataTableViewCell.h"

@implementation ETNoDataTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    [super updateConstraints];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
