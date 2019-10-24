//
//  ETLikeRankHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLikeRankHeaderView.h"

@interface ETLikeRankHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end

@implementation ETLikeRankHeaderView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETLikeRankHeaderViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    self.topView.layer.cornerRadius = 10;
    self.topView.layer.shadowColor = ETMinorColor.CGColor;
    self.topView.layer.shadowOpacity = 0.1;
    self.topView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.bottomView.layer.cornerRadius = 10;
    self.bottomView.layer.shadowColor = ETMinorColor.CGColor;
    self.bottomView.layer.shadowOpacity = 0.1;
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    
    [super updateConstraints];
}

- (void)setViewModel:(ETLikeRankHeaderViewModel *)viewModel {
    if (!viewModel || !viewModel.likeCount || !viewModel.likeRank) {
        return;
    }
    _viewModel = viewModel;
    
    self.numberLabel.text = viewModel.likeRank;
    self.likeCountLabel.text = viewModel.likeCount;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
