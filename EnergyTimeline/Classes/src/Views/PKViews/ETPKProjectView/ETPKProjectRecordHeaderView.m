//
//  ETPKProjectRecordHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRecordHeaderView.h"
#import "ETPKProjectViewModel.h"

@interface ETPKProjectRecordHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerBottomLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewWidth;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKProjectRecordHeaderView

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
//    self.centerView.hidden = YES;
//    self.centerView.backgroundColor = ETMinorBgColor;
    [self.leftView jk_addTopBorderWithColor:ETMinorBgColor width:1];
    [self.leftView jk_addBottomBorderWithColor:ETMinorBgColor width:1];
    [self.rightView jk_addTopBorderWithColor:ETMinorBgColor width:1];
    [self.rightView jk_addBottomBorderWithColor:ETMinorBgColor width:1];
    self.centerView.layer.borderWidth = 1;
    self.centerView.layer.borderColor = ETMinorBgColor.CGColor;
//    [self.centerView jk_addTopBorderWithColor:ETMinorBgColor width:1];
//    [self.centerView jk_addBottomBorderWithColor:ETMinorBgColor width:1];
    self.leftBottomLabel.textColor = ETTextColor_Fourth;
    self.rightBottomLabel.textColor = ETTextColor_Fourth;
    self.centerBottomLabel.textColor = ETTextColor_Fourth;
    
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
        self.centerTopLabel.hidden = [self.viewModel.model.ProjectID isEqualToString:@"35"];
        self.centerBottomLabel.hidden = [self.viewModel.model.ProjectID isEqualToString:@"35"];
        if ([self.viewModel.model.ProjectID isEqualToString:@"35"]) {
            self.centerViewWidth.constant = 1;
            self.leftTopLabel.text = self.viewModel.myReportModel.ReportNum_All;
            self.leftBottomLabel.text = @"总步数";
            self.rightTopLabel.text = self.viewModel.myReportModel.ReportNum_Month;
            self.rightBottomLabel.text = @"本月累计步数";
        } else {
            self.centerViewWidth.constant = ETScreenW / 3.0;
            self.leftTopLabel.text = self.viewModel.myReportModel.ReportNum_All;
            self.leftBottomLabel.text = @"总累计数";
            self.centerTopLabel.text = self.viewModel.myReportModel.ReportFre_All;
            self.centerBottomLabel.text = @"累计打卡";
            self.rightTopLabel.text = self.viewModel.myReportModel.ReportFre_Month;
            self.rightBottomLabel.text = @"本月累计次数";
        }
    }];
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
