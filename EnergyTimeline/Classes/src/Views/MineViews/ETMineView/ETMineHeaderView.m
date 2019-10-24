//
//  ETMineHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineHeaderView.h"
#import "ETImageManager.h"

static NSString * const gender_man = @"gender_man_round_blue";
static NSString * const gender_woman = @"gender_woman_round_red";

@interface ETMineHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;

@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;

@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet UILabel *likesNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *likesRankingLabel;

@property (weak, nonatomic) IBOutlet UIView *noticeHint;

@property (weak, nonatomic) IBOutlet UILabel *noticeHintCountLabel;

@end

@implementation ETMineHeaderView

- (void)updateConstraints {
    
    self.jk_height = IsiPhoneX ? 310 : 286;
    
    self.backgroundButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePictureButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePictureButton.layer.cornerRadius = self.profilePictureButton.jk_height / 2;
    self.profilePictureButton.layer.borderWidth = 2;
    self.profilePictureButton.layer.borderColor = [ETWhiteColor colorWithAlphaComponent:0.4].CGColor;
    self.profilePictureButton.layer.masksToBounds = YES;
    
    self.panelView.layer.cornerRadius = self.panelView.jk_height / 2;
    self.panelView.layer.shadowColor = ETMinorColor.CGColor;
    self.panelView.layer.shadowOpacity = 0.1;
    self.panelView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.noticeHint.layer.cornerRadius = self.noticeHint.jk_width / 2;
    self.noticeHintCountLabel.layer.cornerRadius = self.noticeHintCountLabel.jk_height / 2;
    self.noticeHintCountLabel.layer.masksToBounds = YES;
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETMineViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

//- (void)et_bindViewModel {
//    @weakify(self)
//    [[self.viewModel.changeProfilePictureSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
//        @strongify(self)
//        [self selectPhotos];
//    }];
//}

- (void)setViewModel:(ETMineViewModel *)viewModel {
    if (!viewModel.model) {
        _viewModel = viewModel;
        return;
    }

    _viewModel = viewModel;
    
    [self.backgroundButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.CoverImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ETUserCoverImg_Default]];
    [self.profilePictureButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ETUserPortrait_Default]];
    [self.genderImageView setImage:[UIImage imageNamed:[viewModel.model.Gender integerValue] ? ([viewModel.model.Gender isEqualToString:@"2"] ? gender_woman : gender_man) : @""]];

    self.nickNameLabel.text = viewModel.model.NickName;
    self.briefLabel.text = [NSString stringWithFormat:@"简介:%@", ([viewModel.model.Brief isEqualToString:@""] || !viewModel.model.Brief ? @"暂无" : viewModel.model.Brief)];
    self.integralLabel.text = [NSString stringWithFormat:@"%@积分", viewModel.model.Integral];
    
    self.likesNumLabel.text = viewModel.LikesNum;
    self.likesRankingLabel.text = viewModel.LikesRanking;
    
//    self.noticeHint.hidden = !viewModel.noticeNotReadCount;
    
    self.noticeHintCountLabel.hidden= !viewModel.noticeNotReadCount;
    self.noticeHintCountLabel.text = [NSString stringWithFormat:@"%ld", (long)viewModel.noticeNotReadCount];
}

- (IBAction)mineHomePage:(id)sender {
    [self.viewModel.mineHomePageSubject sendNext:nil];
}

- (IBAction)profilePicture:(id)sender {
    [self.viewModel.profilePictureSubject sendNext:nil];
    
    // 点击头像放大
//    [ETImageManager showFullImage:self.profilePictureButton.imageView];
    
//    [self.viewModel.changeProfilePictureSubject sendNext:nil];

}

- (IBAction)setup:(id)sender {
    [self.viewModel.setupSubject sendNext:nil];
}

- (IBAction)notice:(id)sender {
    [self.viewModel.noticeSubject sendNext:nil];
}

- (IBAction)myInfo:(id)sender {
    [self.viewModel.myInfoSubject sendNext:nil];
}

- (IBAction)drafts:(id)sender {
    [self.viewModel.draftsSubject sendNext:nil];
}

- (IBAction)integralRecord:(id)sender {
    [self.viewModel.integralRecordSubject sendNext:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
