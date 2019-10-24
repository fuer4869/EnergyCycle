//
//  ETRecommendUserCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRecommendUserCollectionViewCell.h"

static NSString * const attention = @"attention_hollow_round";
static NSString * const not_attention = @"notattention_hollow_round";

@interface ETRecommendUserCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@property (nonatomic, assign) BOOL isAttention;

@end

@implementation ETRecommendUserCollectionViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    self.containerView.layer.cornerRadius = 10;
    self.containerView.backgroundColor = ETMinorBgColor;
    self.nameLable.textColor = ETTextColor_Second;
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.1;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    [super updateConstraints];
}

- (void)setViewModel:(ETRecommendUserCollectionViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    _viewModel = viewModel;
    self.headerImageView.layer.cornerRadius = 25;
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.nameLable.text = self.viewModel.model.NickName;
    self.isAttention = [self.viewModel.model.Is_Attention boolValue];
    [self.attentionButton setImage:[UIImage imageNamed:(self.isAttention ? attention : not_attention)] forState:UIControlStateNormal];
}

- (IBAction)attentionClickEvent:(id)sender {
    if (self.viewModel.model) {
        [self.viewModel.attentionSubject sendNext:self.viewModel.model.UserID];
        self.isAttention = !self.isAttention;
        [self.attentionButton setImage:[UIImage imageNamed:(self.isAttention ? attention : not_attention)] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
