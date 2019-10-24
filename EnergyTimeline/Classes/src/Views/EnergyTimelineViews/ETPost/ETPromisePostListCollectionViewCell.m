//
//  ETPromisePostListCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPromisePostListCollectionViewCell.h"

@interface ETPromisePostListCollectionViewCell ()

@end

@implementation ETPromisePostListCollectionViewCell

- (void)updateConstraints {
    self.containerView.layer.cornerRadius = 25;
    
    self.containerView.backgroundColor = ETProjectRelatedBGColor;
    self.projectNameLabel.textColor = ETTextColor_Third;
    
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.10;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.masksToBounds = NO;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETPromisePostListCollectionCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.projectImageView setImage:[UIImage imageNamed:@"mine_bg"]];
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    self.projectImageView.layer.cornerRadius = 25;
    self.projectImageView.clipsToBounds = YES;
    self.projectNameLabel.text = viewModel.model.ProjectName;
    self.numberLabel.text = [NSString stringWithFormat:@"%@%@", viewModel.model.ReportNum, viewModel.model.ProjectUnit];
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalWidth = 0;
    totalWidth += [self.projectImageView sizeThatFits:size].width;
    totalWidth += [self.projectNameLabel sizeThatFits:size].width;
    totalWidth += [self.numberLabel sizeThatFits:size].width;
    totalWidth += 52;
    return CGSizeMake(size.width, size.height);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
