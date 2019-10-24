//
//  ETMineBadgeCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineBadgeCollectionViewCell.h"

@interface ETMineBadgeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *badgeNameLabel;

@end

@implementation ETMineBadgeCollectionViewCell

- (void)setModel:(ETBadgeModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    self.badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.badgeNameLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([model.Is_Have integerValue]) {
        [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
        
        switch ([model.BadgeType integerValue]) {
            case 1: {
                self.badgeNameLabel.textColor = [UIColor jk_colorWithHexString:@"F24D4D"];
            }
                break;
            case 2: {
                self.badgeNameLabel.textColor = [UIColor jk_colorWithHexString:@"2E9887"];
            }
                break;
            case 3: {
                self.badgeNameLabel.textColor = [UIColor jk_colorWithHexString:@"374C7E"];
            }
                break;
            default:
                break;
        }
    } else {
        [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath_Gray]];
        self.badgeImageView.alpha = 0.6;
        self.badgeNameLabel.textColor = [ETGrayColor colorWithAlphaComponent:0.6];
    }
    self.badgeNameLabel.text = model.BadgeName;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
