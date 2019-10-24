//
//  ETIntegralRecordTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralRecordTableViewCell.h"

@interface ETIntegralRecordTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *integralEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralGetTimeLabel;

@end

@implementation ETIntegralRecordTableViewCell

- (void)updateConstraints {
    
    self.integralEventLabel.textColor = ETTextColor_Second;
    self.integralGetTimeLabel.textColor = ETTextColor_Fourth;
    
    [super updateConstraints];
}

- (void)setModel:(IntegralRecordModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    self.integralEventLabel.text = model.IntegralEvent;
    self.integralNumLabel.text = [model.Integral integerValue] > 0 ? [NSString stringWithFormat:@"+%@", model.Integral] : model.Integral;
    self.integralGetTimeLabel.text = model.CreateTime;
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
