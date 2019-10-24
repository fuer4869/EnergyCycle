//
//  ETRadioCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRadioCollectionViewCell.h"

@interface ETRadioCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *radioIcon;

@property (weak, nonatomic) IBOutlet UILabel *radioName;

@end

@implementation ETRadioCollectionViewCell

- (void)setModel:(ETRadioModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    self.radioIcon.layer.cornerRadius = 5;
    self.radioIcon.layer.masksToBounds = YES;
    
    [self.radioIcon sd_setImageWithURL:[NSURL URLWithString:model.Radio_Icon]];
    self.radioName.text = model.RadioName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
