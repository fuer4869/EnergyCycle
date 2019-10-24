//
//  ETAboutTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETAboutTableViewCell.h"

@interface ETAboutTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation ETAboutTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    self.leftLabel.textColor = ETTextColor_Third;
    self.rightLabel.textColor = ETTextColor_First;
    
    [super updateConstraints];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    
    _indexPath = indexPath;
    
    switch (indexPath.row) {
        case 0: {
            self.leftLabel.text = @"电话";
            self.rightLabel.text = @"400-800-6258";
            self.rightLabel.hidden = NO;
            self.arrowImageView.hidden = YES;
        }
            break;
        case 1: {
            self.leftLabel.text = @"给我评分";
        }
            break;
        case 2: {
            self.leftLabel.text = @"功能介绍";
        }
            break;
        default:
            break;
    }
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
