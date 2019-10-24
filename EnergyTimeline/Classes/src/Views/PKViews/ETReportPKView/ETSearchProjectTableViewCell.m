//
//  ETSearchProjectTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2018/1/5.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETSearchProjectTableViewCell.h"

static NSString * const select = @"select_round_black_tick_green";
static NSString * const unselect = @"unselected_round_fill_gray";

@interface ETSearchProjectTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end

@implementation ETSearchProjectTableViewCell

- (void)updateConstraints {
    self.containerView.backgroundColor = ETProjectRelatedBGColor;
    self.projectNameLabel.textColor = ETTextColor_First;
    
    self.projectImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [super updateConstraints];
}

- (void)setModel:(ETPKProjectModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
    self.projectNameLabel.text = model.ProjectName;
}

- (void)setStateType:(ETProjectCellStateType)stateType {
    if (!stateType) {
        return;
    }
    
    _stateType = stateType;
    
    switch (stateType) {
        case ETProjectCellStateTypeNone: {
            self.selectedButton.hidden = YES;
        }
            break;
        case ETProjectCellStateTypeUnCheck: {
            self.selectedButton.hidden = NO;
            [self.selectedButton setImage:[UIImage imageNamed:unselect] forState:UIControlStateNormal];
        }
            break;
        case ETProjectCellStateTypeCheck: {
            self.selectedButton.hidden = NO;
            [self.selectedButton setImage:[UIImage imageNamed:select] forState:UIControlStateNormal];

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
