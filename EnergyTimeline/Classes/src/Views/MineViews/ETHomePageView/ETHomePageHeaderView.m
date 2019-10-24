//
//  ETHomePageView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePageHeaderView.h"
#import "ETImageManager.h"

static NSString * const gender_man = @"gender_man_round_blue";
static NSString * const gender_woman = @"gender_woman_round_red";

static NSString * const mine_addAttention = @"mine_addAttention";
static NSString * const mine_hasAttention = @"mine_hasAttention";

@interface ETHomePageHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *profilePictureImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *attentionCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *briefBottomDistance;

@property (nonatomic, assign) BOOL isAttention;

@property (nonatomic, assign) NSInteger fans;

@end

@implementation ETHomePageHeaderView

- (void)updateConstraints {
    self.backgroundImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePictureImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.jk_height / 2;
    self.profilePictureImageView.layer.borderWidth = 2;
    self.profilePictureImageView.layer.borderColor = [ETWhiteColor colorWithAlphaComponent:0.4].CGColor;
    self.profilePictureImageView.layer.masksToBounds = YES;
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETHomePageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)setViewModel:(ETHomePageViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    if ([viewModel.model.UserID isEqualToString:User_ID]) {
        self.messageButton.hidden = YES;
        self.attentionButton.hidden = YES;
        self.briefBottomDistance.constant = 10;
    } else {
        self.isAttention = [viewModel.model.Is_Attention boolValue];
        self.fans = [viewModel.model.Attention_Me integerValue];
        [self.attentionButton setImage:[UIImage imageNamed:self.isAttention ? mine_hasAttention : mine_addAttention] forState:UIControlStateNormal];
//        self.backgroundImageView.enabled = NO;
//        self.profilePictureImageView.enabled = NO;
    }
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.CoverImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ETUserCoverImg_Default]];
    [self.profilePictureImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ETUserPortrait_Default]];
    self.nickNameLabel.text = viewModel.model.NickName;
    [self.genderImageView setImage:[UIImage imageNamed:[viewModel.model.Gender integerValue] ? ([viewModel.model.Gender isEqualToString:@"2"] ? gender_woman : gender_man) : @""]];
    self.attentionCountLabel.text = viewModel.model.Attention;
    self.fansCountLabel.text = viewModel.model.Attention_Me;
    if (viewModel.model.Brief) {
        self.briefLabel.text = [NSString stringWithFormat:@"简介:%@", viewModel.model.Brief];
    }
    
}

#pragma mark -- Event --

- (IBAction)coverImage:(id)sender {
    if ([self.viewModel.model.UserID isEqualToString:User_ID]) {
        [self.viewModel.setCoverImgSubject sendNext:nil];
    }
}

- (IBAction)profilePicture:(id)sender {
    if ([self.viewModel.model.UserID isEqualToString:User_ID]) {
        [self.viewModel.setProfilePictureSubject sendNext:nil];
    } else {
        [ETImageManager showFullImage:self.profilePictureImageView.imageView];
    }
}

- (IBAction)attentionList:(id)sender {
    [self.viewModel.attentionListSubject sendNext:nil];
}

- (IBAction)fansList:(id)sender {
    [self.viewModel.fansListSubject sendNext:nil];
}

- (IBAction)message:(id)sender {
    [self.viewModel.messageSubject sendNext:nil];
}

- (IBAction)attention:(id)sender {
    [self.viewModel.attentionSubject sendNext:nil];
    self.isAttention = !self.isAttention;
    self.fans += self.isAttention ? 1 : (-1);
    self.fansCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.fans];
    [self.attentionButton setImage:[UIImage imageNamed:(self.isAttention ? mine_hasAttention : mine_addAttention)] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
