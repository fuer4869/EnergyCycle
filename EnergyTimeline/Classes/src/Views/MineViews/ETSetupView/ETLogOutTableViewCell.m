//
//  ETLogOutTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLogOutTableViewCell.h"
#import "UIColor+GradientColors.h"

@interface ETLogOutTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ETLogOutTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    self.containerView.layer.cornerRadius = self.containerView.jk_height / 2;
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.1;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.containerView.layer.borderWidth = 2;
    self.containerView.layer.borderColor = [UIColor colorWithETGradientStyle:ETGradientStyleTopLeftToBottomRight withFrame:self.containerView.frame andColors:@[[UIColor colorWithHexString:@"FF8C6E"], [UIColor colorWithHexString:@"FF5C90"]]].CGColor;
    
    [super updateConstraints];
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
