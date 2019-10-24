//
//  ETIntergralRankHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralRankHeaderView.h"
#import "ETIntegralRankViewModel.h"

@interface ETIntegralRankHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rankSegment;

@property (nonatomic, strong) ETIntegralRankViewModel *viewModel;

@end

@implementation ETIntegralRankHeaderView

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.topView.layer.cornerRadius = 10;
//    self.topView.layer.shadowColor = ETMinorColor.CGColor;
//    self.topView.layer.shadowOpacity = 0.1;
//    self.topView.layer.shadowOffset = CGSizeMake(0, 0);
    
//    self.bottomView.layer.cornerRadius = 10;
//    self.bottomView.layer.shadowColor = ETMinorColor.CGColor;
//    self.bottomView.layer.shadowOpacity = 0.1;
//    self.bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
    
    self.topView.backgroundColor = ETMinorBgColor;
    self.bottomView.backgroundColor = ETMinorBgColor;
    
    self.rankSegment.layer.cornerRadius = 16;
    self.rankSegment.layer.borderWidth = 1;
    self.rankSegment.layer.borderColor = ETMinorColor.CGColor;
    self.rankSegment.clipsToBounds = YES;
    self.rankSegment.tintColor = ETMinorColor;
    NSDictionary *selectedTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName : ETWhiteColor};
    NSDictionary *unselectTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName : ETTextColor_Fourth};
    [self.rankSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    [self.rankSegment setTitleTextAttributes:unselectTextAttributes forState:UIControlStateNormal];
    self.rankSegment.apportionsSegmentWidthsByContent = NO;
    
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
    
    [[self.viewModel.syncSegmentSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *index) {
        @strongify(self)
        self.rankSegment.selectedSegmentIndex = [index integerValue];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.integralLabel.text = self.viewModel.model.AllIntegral;
    }];
}

- (IBAction)integralRule:(id)sender {
    [self.viewModel.integralRuleSubject sendNext:nil];
}

- (IBAction)segment:(id)sender {
    [self.viewModel.syncSegmentSubject sendNext:[NSNumber numberWithInteger:self.rankSegment.selectedSegmentIndex]];
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
