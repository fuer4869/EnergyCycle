//
//  ETIntegralMallHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralMallHeaderView.h"


@interface ETIntegralMallHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *myIntegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ETIntegralMallHeaderView

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.topView.backgroundColor = ETMinorBgColor;
    self.myIntegralLabel.textColor = ETTextColor_Second;
    self.bottomView.backgroundColor = ETMinorBgColor;
    
    self.topView.layer.cornerRadius = 10;
//    self.topView.layer.shadowColor = ETMinorColor.CGColor;
//    self.topView.layer.shadowOpacity = 0.1;
//    self.topView.layer.shadowOffset = CGSizeMake(0, 0);
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
//    self.bottomView.layer.cornerRadius = 10;
    
//    self.bottomView.layer.shadowColor = ETMinorColor.CGColor;
//    self.bottomView.layer.shadowOpacity = 0.1;
//    self.bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETIntegralMallViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)setViewModel:(ETIntegralMallViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.integralLabel.text = viewModel.model.Integral;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
