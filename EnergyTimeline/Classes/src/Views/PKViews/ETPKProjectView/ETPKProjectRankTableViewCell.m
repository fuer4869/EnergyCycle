//
//  ETPKProjectRankTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/12/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRankTableViewCell.h"

static NSString * const likeImage = @"pk_like_red";
static NSString * const dislikeImage = @"pk_like_gray";

@interface ETPKProjectRankTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelTrailing;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) BOOL isLike;

@end

@implementation ETPKProjectRankTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
    self.numberLabel.textColor = ETTextColor_First;
    self.nameLabel.textColor = ETTextColor_First;
    self.countLabel.textColor = [UIColor jk_colorWithHexString:@"E05954"];
    
    self.lineView.backgroundColor = ETMainLineColor;
    
    self.pictureImageView.layer.cornerRadius = self.pictureImageView.jk_height / 2;
    self.pictureImageView.layer.masksToBounds = YES;
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    
    [super updateConstraints];
}

- (void)setModel:(ETDailyPKProjectRankListModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@.", model.Ranking];
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.nameLabel.text = model.NickName;
    if ([model.Limit isEqualToString:@"1"]) {
        self.countLabel.text = [NSString stringWithFormat:@"%@%@", model.Report_Days, model.ProjectUnit];
    } else {
        if ([model.ReportNum integerValue] > [model.Limit integerValue]) {
            self.countLabel.text = [NSString stringWithFormat:@"%@+%@", model.Limit, model.ProjectUnit];
        } else {
            self.countLabel.text = [NSString stringWithFormat:@"%@%@", model.ReportNum, model.ProjectUnit];
        }
    }
    
//    self.countLabelTrailing.constant = [model.Limit isEqualToString:@"1"] ? 30 : 60;
//    self.likeButton.hidden = [model.Limit isEqualToString:@"1"];
    self.isLike = [model.Is_Like boolValue];
    [self.likeButton setImage:[UIImage imageNamed:(self.isLike ? likeImage : dislikeImage)] forState:UIControlStateNormal];
}

- (void)setViewModel:(ETPKProjectViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
}

- (IBAction)like:(id)sender {
    [self.viewModel.likeClickSubject sendNext:self.model];
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
