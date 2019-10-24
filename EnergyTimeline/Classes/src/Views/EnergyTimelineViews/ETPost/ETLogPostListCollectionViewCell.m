//
//  ETLogPostListCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/11/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLogPostListCollectionViewCell.h"

@interface ETLogPostListCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, assign) BOOL isAttention;

@end

@implementation ETLogPostListCollectionViewCell

- (void)updateConstraints {
    self.userImageView.layer.cornerRadius = 25;
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;

    [super updateConstraints];
}

- (void)setViewModel:(ETLogPostListCollectionCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] placeholderImage:[UIImage imageNamed:ETUserPortrait_Default]];
    if (![viewModel.model.UserID isEqualToString:User_ID]) {
        self.isAttention = [viewModel.model.Is_Attention boolValue];
    } else {
        self.isAttention = YES;
    }
    self.attentionButton.hidden = self.isAttention;
    self.userNameLabel.text = viewModel.model.NickName;
    self.userNameLabel.textColor = ETTextColor_Second;
    
}

- (IBAction)attention:(id)sender {
    if (!self.isAttention) {
        [self.viewModel.attentionSubject sendNext:self.viewModel.model.UserID];
        self.isAttention = YES;
        self.attentionButton.hidden = YES;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
