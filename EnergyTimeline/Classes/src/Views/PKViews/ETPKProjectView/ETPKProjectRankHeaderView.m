//
//  ETPKProjectRankHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRankHeaderView.h"
#import "ETPKProjectViewModel.h"

@interface ETPKProjectRankHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralRuleLabel;
@property (weak, nonatomic) IBOutlet UIButton *integralRuleButton;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKProjectRankHeaderView

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
    self.numberLabel.textColor = ETTextColor_Second;
    self.contentLabel.textColor = ETTextColor_Second;
    self.clearLabel.textColor = ETTextColor_Fourth;
    self.integralRuleLabel.textColor = ETTextColor_Fourth;
//    self.integralRuleButton.titleLabel.textColor = ETTextColor_Fourth;
//    self.integralRuleButton.tintColor = ETTextColor_Fourth;
//    [self.integralRuleButton.titleLabel setTextColor:ETTextColor_Fourth];
    
    self.projectImageView.layer.cornerRadius = self.projectImageView.jk_height / 2;
    self.projectImageView.layer.masksToBounds = YES;
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    
}

- (void)et_bindViewModel {
    [self.viewModel.myReportDataCommand execute:nil];
    @weakify(self)
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.myReportModel.FilePath]];
        self.contentLabel.hidden = [self.viewModel.myReportModel.Ranking boolValue];
        if ([self.viewModel.myReportModel.Ranking boolValue]) {
            self.numberLabel.text = [NSString stringWithFormat:@"第%@名", self.viewModel.myReportModel.Ranking];
        }
        self.clearLabel.hidden = ![self.viewModel.model.ProjectID isEqualToString:@"50"];

//        self.contentLabel.text = [NSString stringWithFormat:@"比昨天进步了%@%@", self.viewModel.myReportModel.UpNum, self.viewModel.myReportModel.ProjectUnit];
    }];
}

- (IBAction)projectAlarm:(id)sender {
    [self.viewModel.projectAlarmSubject sendNext:nil];
}


- (IBAction)integralRule:(id)sender {
    [self.viewModel.integralRuleSubject sendNext:nil];
}

#pragma mark -- lazyLoad --

- (ETPKProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectViewModel alloc] init];
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
