//
//  ETPKProjectRecordTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/12/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRecordTableViewCell.h"

@interface ETPKProjectRecordTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIView *timeLineView;

@end

@implementation ETPKProjectRecordTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
    self.timeLabel.textColor = ETTextColor_Third;
    self.projectNameLabel.textColor = [UIColor jk_colorWithHexString:@"FFA327"];
    self.countLabel.textColor = ETTextColor_Second;
    self.numberLabel.textColor = ETTextColor_Second;
    
    self.timeLineView.backgroundColor = ETMinorBgColor;
    
    self.projectImageView.layer.cornerRadius = self.projectImageView.jk_height / 2;
    self.projectImageView.layer.masksToBounds = YES;
    self.projectImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [super updateConstraints];
}

- (void)setModel:(ETPKProjectRecordModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
//    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@", [NSDate jk_stringWithDate:[NSDate jk_dateWithString:model.CreateDate format:[NSDate jk_ymdHmsFormat]] format:@"MM-dd"], [NSDate jk_stringWithDate:[NSDate jk_dateWithString:model.CreateDate format:[NSDate jk_ymdHmsFormat]] format:@"HH:mm"]];
    self.timeLabel.text = [NSDate jk_stringWithDate:[NSDate jk_dateWithString:model.CreateDate format:[NSDate jk_ymdHmsFormat]] format:@"MM-dd"];

    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
    self.projectNameLabel.text = [NSString stringWithFormat:@"#%@", model.ProjectName];
    self.countLabel.text = [NSString stringWithFormat:@"%@%@", model.ReportNum, model.ProjectUnit];
    self.numberLabel.text = [NSString stringWithFormat:@"第%@名", model.Ranking];
    
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
