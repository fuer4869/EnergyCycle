//
//  ETAloneProjectChartViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/8/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETAloneProjectChartViewCell.h"

@interface ETAloneProjectChartViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectUnitLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ETAloneProjectChartViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMinorBgColor;
    
    self.projectImageView.layer.cornerRadius = self.projectImageView.jk_height / 2;
    self.projectImageView.layer.masksToBounds = YES;

    self.lineView.backgroundColor = ETMainLineColor;
    self.createTimeLabel.textColor = ETTextColor_First;
    self.reportNumLabel.textColor = ETTextColor_First;
    self.projectUnitLabel.textColor = ETTextColor_First;
    
//    self.projectImageView.layer.shadowColor = ETBlackColor.CGColor;
//    self.projectImageView.layer.shadowOpacity = 0.10;
//    self.projectImageView.layer.shadowOffset = CGSizeMake(0, 0);
    
    [super updateConstraints];
}

- (void)setViewModel:(ETProjectChartTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    
    self.createTimeLabel.text = [NSDate jk_stringWithDate:[NSDate jk_dateWithString:viewModel.model.CreateTime format:[NSDate jk_ymdHmsFormat]] format:[NSDate jk_ymdFormat]];
    
    self.reportNumLabel.text = viewModel.model.ReportNum;
    
    self.projectUnitLabel.text = viewModel.model.ProjectUnit;
    
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
