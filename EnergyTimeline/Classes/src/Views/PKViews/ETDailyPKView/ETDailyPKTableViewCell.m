//
//  ETDailyPKTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKTableViewCell.h"

static NSString * const likeImage = @"like_red";
static NSString * const dislikeImage = @"like_gray";

@interface ETDailyPKTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger likes;

@end

@implementation ETDailyPKTableViewCell

- (void)updateConstraints {
    self.backgroundColor = [UIColor clearColor];
    self.userButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userButton.layer.cornerRadius = self.userButton.jk_height / 2;
    self.userButton.clipsToBounds = YES;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETDailyPKTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    _viewModel = viewModel;
    
//    [self.headImageView setImage:[UIImage imageNamed:@"mine_bg"]];
//    if (viewModel.model.ProfilePicture) {
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture]];
//    } else {
//        [self.headImageView setImage:[UIImage imageNamed:ETUserPortrait_Default]];
//    }
    
    [self.userButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:ETUserPortrait_PlaceHolderImage];

    
    self.rankingLabel.text = [NSString stringWithFormat:@"%@.", viewModel.model.Ranking];
    self.nameLabel.text = viewModel.model.NickName;
    
    if ([viewModel.model.Limit isEqualToString:@"1"]) {
        self.numberLabel.text = [NSString stringWithFormat:@"%@%@", viewModel.model.Report_Days, viewModel.model.ProjectUnit];
    } else {
        if ([self.viewModel.model.ReportNum integerValue] > [self.viewModel.model.Limit integerValue]) {
            self.numberLabel.text = [NSString stringWithFormat:@"%@+%@", self.viewModel.model.Limit, self.viewModel.model.ProjectUnit];
        } else {
            self.numberLabel.text = [NSString stringWithFormat:@"%@%@", self.viewModel.model.ReportNum, self.viewModel.model.ProjectUnit];
        }
    }
    
//    if (![self.viewModel.model.UserID isEqualToString:User_ID]) {
    self.isLike = [self.viewModel.model.Is_Like boolValue];
    [self.likeButton setImage:[UIImage imageNamed:(self.isLike ? likeImage : dislikeImage)] forState:UIControlStateNormal];
    self.likeCountLabel.text = viewModel.model.Likes;
    self.likes = [self.viewModel.model.Likes integerValue];
//        @weakify(self)
//        [[self.likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self)
//            [self.viewModel.likeClickSubject sendNext:viewModel.model.ReportID];
//            self.isLike = !self.isLike;
//            self.likes += self.isLike ? 1 : (-1);
//            self.likeCountLabel.text = [NSString stringWithFormat:@"%d", self.likes];
//            [_likeButton setImage:[UIImage imageNamed:(self.isLike ? likeImage : dislikeImage)] forState:UIControlStateNormal];
//        }];
//    } else {
//        self.numberLabel.hidden = YES;
//        self.likeCountLabel.hidden = YES;
//        self.likeButton.hidden = YES;
//    }
    
    
    
    CGFloat cornerRadius = 10;
    UIBezierPath *path;
    
    switch (self.type) {
        case ETDailyPKTableViewCellTypeTop: {
            CGRect rect = self.containerView.bounds;
            rect.size.height += 1;
            rect.size.width = self.contentView.jk_width - 20;
            
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
        case ETDailyPKTableViewCellTypeBottom: {
            CGRect rect = self.containerView.bounds;
            rect.size.height += 1;
            rect.size.width = self.contentView.jk_width - 20;
            
            path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
        case ETDailyPKTableViewCellTypeDefault:
        default: {
            [self.containerView.layer.mask setMask:nil];
            return;
        }
            break;
    }
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.containerView.bounds;
    maskLayer.path = path.CGPath;
    self.containerView.layer.mask = maskLayer;
    
}

- (IBAction)homePage:(id)sender {
    [self.viewModel.homePageSubejct sendNext:self.viewModel.model.UserID];
}

- (IBAction)likeClickEvent:(id)sender {
    [self.viewModel.likeClickSubject sendNext:self.viewModel.model.ReportID];
    self.isLike = !self.isLike;
    self.likes += self.isLike ? 1 : (-1);
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.likes];
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
