//
//  ETPKCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKCollectionViewCell.h"

static NSString * const medal_first = @"medal_first";
static NSString * const medal_second = @"medal_second";
static NSString * const medal_third = @"medal_third";

@interface ETPKCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectUnitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *reportDaysLabel;
@property (weak, nonatomic) IBOutlet UIImageView *medalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmImageView;
@property (weak, nonatomic) IBOutlet UIImageView *trainImageView;

@end

@implementation ETPKCollectionViewCell

- (void)updateConstraints {
    self.containerView.layer.cornerRadius = 4;
    self.containerView.clipsToBounds = YES;
    self.containerView.backgroundColor = ETMinorBgColor;
    
    [super updateConstraints];
}

- (void)setModel:(ETDailyPKProjectRankListModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    NSInteger report = [model.ReportID integerValue];
    
    self.rankingLabel.hidden = !report;
    
    NSInteger rank = [model.Ranking integerValue];
    if (rank == 1 || rank == 2 || rank == 3) {
        self.medalImageView.hidden = NO;
        self.rankingLabel.hidden = YES;
        [self.medalImageView setImage:[UIImage imageNamed:(rank == 1 ? medal_first : (rank == 2 ? medal_second : medal_third))]];
    } else {
        self.medalImageView.hidden = YES;
    }
    
    self.rankingLabel.text = model.Ranking;
    self.projectNameLabel.text = model.ProjectName;
    self.reportNumLabel.text = report ? [NSString stringWithFormat:@"%@ %@", ([model.ProjectUnit isEqualToString:@"天"] ? model.Report_Days : model.ReportNum), model.ProjectUnit] : [NSString stringWithFormat:@"-- %@", model.ProjectUnit];
    self.reportDaysLabel.text = [NSString stringWithFormat:@"本月累计 %@ %@", model.Report_Num_Month, model.ProjectUnit];
    self.reportNumLabel.textColor = report ? ETMarkYellowColor : [ETTextColor_First colorWithAlphaComponent:0.2];
    self.projectNameLabel.textColor = ETTextColor_Second;
    
    self.alarmImageView.hidden = ![model.ClockID integerValue];
    self.trainImageView.hidden = ![model.Is_Train boolValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
