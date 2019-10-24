//
//  ETChatListTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETChatListTableViewCell.h"

#import "NSString+Time.h"

@interface ETChatListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *unRead;

@end

@implementation ETChatListTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMinorBgColor;
    
    self.nickNameLabel.textColor = ETTextColor_First;
    self.messageLabel.textColor = ETTextColor_Fourth;
    self.timeLabel.textColor = ETTextColor_Fourth;
    
    self.unRead.backgroundColor = ETRedColor;
    
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.layer.cornerRadius = self.userImageView.jk_height / 2;
    self.userImageView.clipsToBounds = YES;
    
    self.unRead.layer.cornerRadius = self.unRead.jk_height / 2;
    self.unRead.clipsToBounds = YES;
    
    [super updateConstraints];
}

- (void)setModel:(ChatListModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.ProfilePicture] placeholderImage:[UIImage imageNamed:ETUserPortrait_Default]];
    self.nickNameLabel.text = model.NickName;
    self.messageLabel.text = model.MessageContent;
//    self.timeLabel.text = [NSDate jk_timeInfoWithDateString:model.CreateTime];
    self.timeLabel.text = [NSString timeInfoWithDateString:model.CreateTime];

    [self.unRead setTitle:self.model.NotRead_Num forState:UIControlStateNormal];
    self.unRead.hidden = ![self.model.NotRead_Num integerValue];
    
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
