//
//  ETBannerCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETBannerCollectionViewCell.h"

@interface ETBannerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *bannerNameLabel;

@end

@implementation ETBannerCollectionViewCell

- (void)updateConstraints {
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [super updateConstraints];
}

- (void)setModel:(ETBannerModel *)model {
    if (!model) {
        return;
    }
    _model = model;
    
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
    self.bannerNameLabel.text = model.BannerName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
