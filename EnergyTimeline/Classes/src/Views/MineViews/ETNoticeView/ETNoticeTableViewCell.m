//
//  ETNoticeTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNoticeTableViewCell.h"

@interface ETNoticeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ETNoticeTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
//    self.timeLabel.textColor = ETTextColor_Second;
    self.timeLabel.backgroundColor = ETMinorBgColor;
    self.containerView.backgroundColor = ETMinorBgColor;
    self.titleLabel.textColor = ETTextColor_First;
    self.contentLabel.textColor = ETTextColor_Third;
    self.lineView.backgroundColor = ETMainLineColor;
    
    self.timeLabel.layer.cornerRadius = 10;
    self.timeLabel.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 10;
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.1;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    [super updateConstraints];
}

- (void)setModel:(NoticeModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    self.timeLabel.text = self.model.CreateTime;
    
    self.titleLabel.text = self.model.NoticeEvent;
    self.contentLabel.text = self.model.NoticeContent;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.timeLabel sizeThatFits:size].height;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += 85;
    return CGSizeMake(size.width, totalHeight);
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
