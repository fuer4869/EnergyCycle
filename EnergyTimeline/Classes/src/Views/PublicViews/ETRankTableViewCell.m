//
//  ETRankTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRankTableViewCell.h"

@interface ETRankTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ETRankTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.containerView.backgroundColor = ETMinorBgColor;
    
    self.numberLabel.textColor = ETTextColor_First;
    self.nameLabel.textColor = ETTextColor_First;
    self.countLabel.textColor = [UIColor jk_colorWithHexString:@"E05954"];
    
    self.lineView.backgroundColor = ETMainLineColor;
    
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.1;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    [super updateConstraints];
}

- (void)setLikeRankViewModel:(ETLikeRankListTableViewCellViewModel *)likeRankViewModel {
    if (!likeRankViewModel.model) {
        return;
    }
    _likeRankViewModel = likeRankViewModel;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@.", likeRankViewModel.model.Ranking];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:likeRankViewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.headImageView.layer.cornerRadius = 18;
    self.headImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = likeRankViewModel.model.NickName;
    
    self.countLabel.text = [NSString stringWithFormat:@"%@赞", likeRankViewModel.model.Likes];
    
    
}

- (void)setSignRankViewModel:(ETSignRankListTableViewCellViewModel *)signRankViewModel {
    if (!signRankViewModel.model) {
        return;
    }
    _signRankViewModel = signRankViewModel;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@.", signRankViewModel.model.Ranking];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:signRankViewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.headImageView.layer.cornerRadius = 18;
    self.headImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = signRankViewModel.model.NickName;
    
    self.countLabel.text = [NSString stringWithFormat:@"%@天", signRankViewModel.model.EarlyDays];
}

- (void)setIntegralRankViewModel:(ETIntegralRankTableViewCellViewModel *)integralRankViewModel {
    if (!integralRankViewModel.model) {
        return;
    }
    
    _integralRankViewModel = integralRankViewModel;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@.", integralRankViewModel.model.Ranking];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:integralRankViewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.headImageView.layer.cornerRadius = 18;
    self.headImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = integralRankViewModel.model.NickName;
    
//    self.countLabel.text = integralRankViewModel.model.Integral;
    self.countLabel.text = [NSString stringWithFormat:@"%@分", integralRankViewModel.model.AllIntegral];

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
