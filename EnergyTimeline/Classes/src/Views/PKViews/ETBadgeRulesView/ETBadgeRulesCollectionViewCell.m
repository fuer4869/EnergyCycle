//
//  ETBadgeRulesCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETBadgeRulesCollectionViewCell.h"

@interface ETBadgeRulesCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@end

@implementation ETBadgeRulesCollectionViewCell

- (void)setViewModel:(ETBadgeRulesCollectionViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    if ([viewModel.model.Is_Have isEqualToString:@"0"]) {
        self.badgeImageView.alpha = 0.6;
    }
    self.badgeLabel.text = viewModel.model.BadgeName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
