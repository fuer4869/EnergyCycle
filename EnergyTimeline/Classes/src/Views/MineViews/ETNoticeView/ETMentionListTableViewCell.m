//
//  ETMentionListTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMentionListTableViewCell.h"

#import "NSString+Time.h"

@interface ETMentionListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;


@end

@implementation ETMentionListTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMinorBgColor;

    self.nickNameLabel.textColor = ETTextColor_First;
    self.contentLabel.textColor = ETTextColor_Third;
    self.timeLabel.textColor = ETTextColor_Third;
    
    self.userButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userButton.layer.cornerRadius = self.userButton.jk_height / 2;
    self.userButton.clipsToBounds = YES;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETMentionListTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.userButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:ETUserPortrait_PlaceHolderImage];
    
    self.nickNameLabel.text = viewModel.model.NickName;
//    self.timeLabel.text = [NSDate jk_timeInfoWithDateString:viewModel.model.CreateTime];
    self.timeLabel.text = [NSString timeInfoWithDateString:viewModel.model.CreateTime];
    self.contextLabel.text = @"提到我";
    self.contentLabel.text = viewModel.model.PostContent;
    self.contentLabel.hidden = viewModel.model.FilePath ? YES : NO;
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    self.firstImageView.clipsToBounds = YES;
}

- (IBAction)homePage:(id)sender {
    [self.viewModel.homePageSubject sendNext:self.viewModel.model.UserID];
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
