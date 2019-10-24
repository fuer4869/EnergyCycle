//
//  ETMineBadgeHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineBadgeHeaderView.h"
#import "ETMineBadgeViewModel.h"

#import "UIColor+GradientColors.h"

static NSString * const badgeWall = @"mine_badgeWall";
static NSString * const badgeWall_X = @"mine_badgeWall_X";

@interface ETMineBadgeHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *badgeWall;
@property (weak, nonatomic) IBOutlet UILabel *badgeCountLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeCountView;

@end

@implementation ETMineBadgeHeaderView

- (void)updateConstraints {
//    self.backgroundColor = [UIColor colorWithETGradientStyle:ETGradientStyleTopLeftToBottomRight withFrame:CGRectMake(0, 0, ETScreenW, 124 + kNavHeight) andColors:@[[UIColor colorWithHexString:@"363795"], [UIColor colorWithHexString:@"8363AF"]]];
    [self.badgeWall setImage:[UIImage imageNamed:IsiPhoneX ? badgeWall_X : badgeWall] forState:UIControlStateNormal];
    self.badgeCountView.layer.cornerRadius = self.badgeCountView.jk_height / 2;
    self.badgeCountView.layer.masksToBounds = YES;
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETMineBadgeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)setViewModel:(ETMineBadgeViewModel *)viewModel {
    if (!viewModel.badgeCount) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.badgeCountLabel.text = [NSString stringWithFormat:@"获得: %ld个", viewModel.badgeCount];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
