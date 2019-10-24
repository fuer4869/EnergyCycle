//
//  ETIntegralRankFooterView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralRankFooterView.h"
#import "ETIntegralRankViewModel.h"

@interface ETIntegralRankFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic, strong) ETIntegralRankViewModel *viewModel;

@end

@implementation ETIntegralRankFooterView

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
    self.leftLabel.textColor = ETTextColor_First;
    self.centerLeftLabel.textColor = ETTextColor_First;
    self.centerRightLabel.textColor = ETTextColor_Fourth;
    self.rightLabel.textColor = [UIColor jk_colorWithHexString:@"E05954"];
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETIntegralRankViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.leftLabel.text = @"我";
        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
        self.pictureImageView.layer.cornerRadius = 18;
        self.pictureImageView.layer.masksToBounds = YES;
        self.centerLeftLabel.text = [NSString stringWithFormat:@"第%@名", self.viewModel.currentSegment ? self.viewModel.model.FriendRanking : self.viewModel.model.Ranking];
        
        NSString *exceedNum = self.viewModel.currentSegment ? self.viewModel.model.Friend : self.viewModel.model.World;
        if ([exceedNum integerValue] > 0) {
            self.centerRightLabel.text = [NSString stringWithFormat:@"↑%@", exceedNum];
            self.centerRightLabel.textColor = [UIColor jk_colorWithHexString:@"0BC10B"];
        } else if ([exceedNum integerValue] == 0) {
            self.centerRightLabel.text = [NSString stringWithFormat:@"--"];
            self.centerRightLabel.textColor = ETTextColor_Fourth;
        } else {
            exceedNum = [exceedNum substringFromIndex:1];
            self.centerRightLabel.text = [NSString stringWithFormat:@"↓%@", exceedNum];
            self.centerRightLabel.textColor = ETRedColor;
        }
        
        self.rightLabel.text = [NSString stringWithFormat:@"%@分", self.viewModel.model.AllIntegral];
        
    }];
}

#pragma mark -- lazyLoad --

- (ETIntegralRankViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETIntegralRankViewModel alloc] init];
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
