//
//  ETReportPKPoolProjectCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKPoolProjectCollectionViewCell.h"

@interface ETReportPKPoolProjectCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectUnitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;

@end

@implementation ETReportPKPoolProjectCollectionViewCell

- (void)updateConstraints {
    self.containerView.layer.cornerRadius = 4;
    
    self.containerView.backgroundColor = ETProjectRelatedBGColor;
    self.projectNameLabel.textColor = ETTextColor_First;
    self.reportNumLabel.textColor = ETTextColor_First;
    self.projectUnitLabel.textColor = ETTextColor_First;
    
    [super updateConstraints];
}

- (void)setModel:(ETDailyPKProjectRankListModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    NSInteger report = [model.ReportID integerValue];
    
    self.projectNameLabel.text = model.ProjectName;
    self.reportNumLabel.text = report ? ([model.ProjectUnit isEqualToString:@"天"] ? @"1" : model.ReportNum) : @"-";
    self.projectUnitLabel.text = model.ProjectUnit;
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:report ? model.FilePath : model.Gray_FilePath]];
    
    self.projectNameLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
