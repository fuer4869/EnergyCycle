//
//  DailyPromiseTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/3.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "DailyPromiseTableViewCell.h"

@implementation DailyPromiseTableViewCell

- (void)getDataWithModel:(PromiseDetailModel *)model {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.leftView.backgroundColor = ETMinorBgColor;
    self.containerView.backgroundColor = ETMinorBgColor;
    
    self.containerView.layer.cornerRadius = 5; // 内容视图圆角
    self.leftView.transform = CGAffineTransformMakeRotation (45 * (M_PI / 180.0f));
    self.leftView.layer.cornerRadius = 3;
    
    self.point.layer.cornerRadius = self.point.frame.size.height / 2;
    if ([model.Is_Finish isEqualToString:@"1"]) {
        self.point.backgroundColor = ETTextColor_First;
        self.completeLabel.text = @"完成";
    } else {
        self.point.backgroundColor = ETTextColor_Third;
        self.completeLabel.text = @"未完成";
    }
    
    if ([model.ProjectUnit isEqualToString:@"天"]) {
        self.promise.text = [NSString stringWithFormat:@"%@", model.ProjectName];
    } else {
        self.promise.text = [NSString stringWithFormat:@"%@%@%@", model.ProjectName, model.ReportNum, model.ProjectUnit];
    }
    
//    self.containerView.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
//    self.containerView.layer.shadowOpacity = 0.2;
//    self.containerView.layer.shadowRadius = 3;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    
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
