//
//  ETReportPKCompletedCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/10/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKCompletedCollectionViewCell.h"

@interface ETReportPKCompletedCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayRankingLabel;

@end

@implementation ETReportPKCompletedCollectionViewCell

- (void)updateConstraints {
    self.containerView.layer.cornerRadius = 5;
    
    self.containerView.backgroundColor = ETProjectRelatedBGColor;
    self.projectNameLabel.textColor = ETTextColor_First;
    self.todayTotalLabel.textColor = ETTextColor_Third;
    self.todayRankingLabel.textColor = ETTextColor_Third;
    
    [super updateConstraints];
}

- (void)setModel:(ETDailyPKProjectRankListModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];

    self.projectNameLabel.text = model.ProjectName;
    
    self.todayTotalLabel.text = [NSString stringWithFormat:@"今日累计: %@%@", model.ReportNum, model.ProjectUnit];
    
    self.todayRankingLabel.text = [NSString stringWithFormat:@"今日排名: %@", model.Ranking];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
