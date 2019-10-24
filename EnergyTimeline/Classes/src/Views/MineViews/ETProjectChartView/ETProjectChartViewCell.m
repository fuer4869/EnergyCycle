//
//  ETProjectChartViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/8/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectChartViewCell.h"

@interface ETProjectChartViewCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;

@property (weak, nonatomic) IBOutlet UILabel *projectName;

@property (weak, nonatomic) IBOutlet UILabel *reportFre;

@property (weak, nonatomic) IBOutlet UILabel *projectUnit;

@end

@implementation ETProjectChartViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
    self.projectImageView.layer.cornerRadius = self.projectImageView.jk_height / 2;
    self.projectImageView.layer.masksToBounds = YES;

    self.lineView.backgroundColor = ETMainLineColor;
    self.projectName.textColor = ETTextColor_First;
    self.reportFre.textColor = ETTextColor_First;
    self.projectUnit.textColor = ETTextColor_First;
    
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
    
    self.projectName.text = viewModel.model.ProjectName;
    
    self.reportFre.text = viewModel.model.ReportNum;
    
    self.projectUnit.text = viewModel.model.ProjectUnit;
    
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
