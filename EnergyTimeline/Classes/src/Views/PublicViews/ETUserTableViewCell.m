//
//  ETUserTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUserTableViewCell.h"

static NSString * const attention_bidirectional = @"hollow_bidirectionalArrows_round_gray";
static NSString * const attention_add = @"hollow_plus_round_red";
static NSString * const attention_tick = @"hollow_tick_round_green";

@interface ETUserTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (weak, nonatomic) IBOutlet UIButton *lll;

@property (nonatomic, assign) BOOL isAttentionMe;
@property (nonatomic, assign) BOOL isAttention;

@end

@implementation ETUserTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.containerView.backgroundColor = ETMinorBgColor;
    self.nameLabel.textColor = ETTextColor_First;
    self.briefLabel.textColor = ETTextColor_Second;
//    self.containerView.layer.cornerRadius = 10;
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.1;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    [super updateConstraints];}

- (void)setSearchUserViewModel:(ETSearchUserTableViewCellViewModel *)searchUserViewModel {
    if (!searchUserViewModel.model) {
        return;
    }
    _searchUserViewModel = searchUserViewModel;
    
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.searchUserViewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.nameLabel.text = self.searchUserViewModel.model.NickName;
    self.briefLabel.text = self.searchUserViewModel.model.Brief;

    if (![self.searchUserViewModel.model.UserID isEqualToString:User_ID]) {
        self.isAttentionMe = [self.searchUserViewModel.model.Is_Attention_Me boolValue];
        self.isAttention = [self.searchUserViewModel.model.Is_Attention boolValue];
        [self attentionImage];
    } else {
        self.clickButton.hidden = YES;
    }
}

- (void)setNovelFansListViewModel:(ETNewFansListTableViewCellViewModel *)novelFansListViewModel {
    if (!novelFansListViewModel.model) {
        return;
    }
    
    _novelFansListViewModel = novelFansListViewModel;
    
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.novelFansListViewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.nameLabel.text = self.novelFansListViewModel.model.NickName;
    self.briefLabel.text = self.novelFansListViewModel.model.Brief;
    
    if (![self.novelFansListViewModel.model.UserID isEqualToString:User_ID]) {
        self.isAttentionMe = [self.novelFansListViewModel.model.Is_Attention_Me boolValue];
        self.isAttention = [self.novelFansListViewModel.model.Is_Attention boolValue];
        [self attentionImage];
    } else {
        self.clickButton.hidden = YES;
    }
}

- (void)setAttentionListViewModel:(ETAttentionListTableViewCellViewModel *)attentionListViewModel {
    if (!attentionListViewModel.model) {
        return;
    }
    
    _attentionListViewModel = attentionListViewModel;
    
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.attentionListViewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.nameLabel.text = self.attentionListViewModel.model.NickName;
    self.briefLabel.text = self.attentionListViewModel.model.Brief;
    
    if (![self.attentionListViewModel.model.UserID isEqualToString:User_ID]) {
        self.isAttentionMe = [self.attentionListViewModel.model.Is_Attention_Me boolValue];
        self.isAttention = [self.attentionListViewModel.model.Is_Attention boolValue];
        [self attentionImage];
    } else {
        self.clickButton.hidden = YES;
    }
}

- (void)setFansListViewModel:(ETFansListTableViewCellViewModel *)fansListViewModel {
    if (!fansListViewModel.model) {
        return;
    }
    
    _fansListViewModel = fansListViewModel;
    
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.fansListViewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    self.nameLabel.text = self.fansListViewModel.model.NickName;
    self.briefLabel.text = self.fansListViewModel.model.Brief;
    
    if (![self.fansListViewModel.model.UserID isEqualToString:User_ID]) {
        self.isAttentionMe = [self.fansListViewModel.model.Is_Attention_Me boolValue];
        self.isAttention = [self.fansListViewModel.model.Is_Attention boolValue];
        [self attentionImage];
    } else {
        self.clickButton.hidden = YES;
    }
}

- (IBAction)clickEvent:(id)sender {
    if (self.searchUserViewModel.model) {
        [self.searchUserViewModel.attentionSubject sendNext:self.searchUserViewModel.model.UserID];
        self.isAttention = !self.isAttention;
        [self attentionImage];
    }
    if (self.novelFansListViewModel.model) {
        [self.novelFansListViewModel.attentionSubject sendNext:self.novelFansListViewModel.model.UserID];
        self.isAttention = !self.isAttention;
        [self attentionImage];
    }
    if (self.attentionListViewModel.model) {
        [self.attentionListViewModel.attentionSubject sendNext:self.attentionListViewModel.model.UserID];
        self.isAttention = !self.isAttention;
        [self attentionImage];
    }
    if (self.fansListViewModel.model) {
        [self.fansListViewModel.attentionSubject sendNext:self.fansListViewModel.model.UserID];
        self.isAttention = !self.isAttention;
        [self attentionImage];
    }
}

- (void)attentionImage {
    if (self.isAttentionMe && self.isAttention) {
        [self.clickButton setImage:[UIImage imageNamed:attention_bidirectional] forState:UIControlStateNormal];
    } else if (self.isAttention) {
        [self.clickButton setImage:[UIImage imageNamed:attention_tick] forState:UIControlStateNormal];
    } else {
        [self.clickButton setImage:[UIImage imageNamed:attention_add] forState:UIControlStateNormal];
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
