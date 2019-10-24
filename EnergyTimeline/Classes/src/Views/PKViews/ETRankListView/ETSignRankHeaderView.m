//
//  ETSignRankHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSignRankHeaderView.h"

@interface ETSignRankHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *totalSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSignUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *continuousSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *continuousSignUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unnumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *signCountLabel;


@end

@implementation ETSignRankHeaderView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETSignRankHeaderViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    self.topView.layer.cornerRadius = 10;
//    self.topView.layer.shadowColor = ETMinorColor.CGColor;
//    self.topView.layer.shadowOpacity = 0.1;
//    self.topView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.centerView.layer.cornerRadius = 10;
//    self.centerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.centerView.layer.shadowOpacity = 0.1;
//    self.centerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.bottomView.layer.cornerRadius = 10;
//    self.bottomView.layer.shadowColor = ETMinorColor.CGColor;
//    self.bottomView.layer.shadowOpacity = 0.1;
//    self.bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.topView.backgroundColor = ETMinorBgColor;
    self.centerView.backgroundColor = ETMinorBgColor;
    self.bottomView.backgroundColor = ETMinorBgColor;
    
    self.unnumberLabel.backgroundColor = ETMinorBgColor;

    [super updateConstraints];
}

- (void)setViewModel:(ETSignRankHeaderViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    _viewModel = viewModel;
    self.totalSignLabel.text = viewModel.model.CheckInDays;
    self.continuousSignLabel.text = viewModel.model.ContinueDays;
    self.numberLabel.text = viewModel.model.EarlyRanking;
    self.signCountLabel.text = viewModel.model.EarlyDays;
    self.unnumberLabel.hidden = ![viewModel.model.EarlyRanking isEqualToString:@"0"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
