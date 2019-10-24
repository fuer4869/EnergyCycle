//
//  ETSignRankListTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2018/1/19.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETSignRankListTableViewCell.h"

static NSString * const likeImage = @"pk_like_red";
static NSString * const dislikeImage = @"pk_like_gray";

@interface ETSignRankListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) BOOL isLike;

@end

@implementation ETSignRankListTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.containerView.backgroundColor = ETMinorBgColor;
    
    self.numberLabel.textColor = ETTextColor_First;
    self.nameLabel.textColor = ETTextColor_First;
    self.countLabel.textColor = [UIColor jk_colorWithHexString:@"E05954"];
    
    [self.pictureImageView jk_setRoundedCorners:UIRectCornerAllCorners radius:self.pictureImageView.jk_height / 2];

    self.lineView.backgroundColor = ETMainLineColor;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETSignRankListTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    self.numberLabel.text = [NSString stringWithFormat:@"%@.", viewModel.model.Ranking];
    
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    
    self.nameLabel.text = viewModel.model.NickName;
    
    self.countLabel.text = [NSString stringWithFormat:@"%@天", viewModel.model.EarlyDays];
    
    self.isLike = [viewModel.model.Is_Like boolValue];
    [self.likeButton setImage:[UIImage imageNamed:(self.isLike ? likeImage : dislikeImage)] forState:UIControlStateNormal];
}

- (IBAction)like:(id)sender {
    [self.viewModel.likeClickSubject sendNext:self.viewModel.model.UserID];
    self.isLike = !self.isLike;
    [self.likeButton setImage:[UIImage imageNamed:(self.isLike ? likeImage : dislikeImage)] forState:UIControlStateNormal];
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
