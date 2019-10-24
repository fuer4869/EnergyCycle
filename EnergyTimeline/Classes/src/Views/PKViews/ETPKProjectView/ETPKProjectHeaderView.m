//
//  ETPKProjectHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2018/1/10.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectHeaderView.h"
#import "ETPKProjectViewModel.h"

@interface ETPKProjectHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKProjectHeaderView

- (void)updateConstraints {
    
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.layer.masksToBounds = YES;
    [self.coverButton jk_setImagePosition:LXMImagePositionTop spacing:8];
    [self.portraitButton jk_setRoundedCorners:UIRectCornerAllCorners radius:self.portraitButton.jk_height / 2];
    self.nameLabel.textColor = ETMarkYellowColor;
    self.textLabel.textColor = ETTextColor_First;
    
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.coverButton.hidden = !([self.viewModel.rankFirstModel.UserID isEqualToString:User_ID] || !self.viewModel.rankFirstModel); // 如果用户为第一名时可以设置封面
        self.topView.hidden = !self.viewModel.rankFirstModel; // 如果没有第一名(没人提交数据)顶部view隐藏
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.rankFirstModel ? self.viewModel.rankFirstModel.PKCoverImg : self.viewModel.myReportModel.PKCoverImg] placeholderImage:[UIImage imageNamed:ETUserPKCoverImgLittle_Default]];
        [self.portraitButton sd_setImageWithURL:[NSURL URLWithString:self.viewModel.rankFirstModel.ProfilePicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ETUserPortrait_Default]];
        self.nameLabel.text = self.viewModel.rankFirstModel.NickName;
    }];
    
}
- (IBAction)setup:(id)sender {
    [self.viewModel.setupPKCoverSubject sendNext:nil];
}

#pragma mark -- lazyLoad --

- (ETPKProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectViewModel alloc]  init];
    }
    return _viewModel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
