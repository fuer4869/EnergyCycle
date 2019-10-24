//
//  ETReportPKTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/8/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKTableViewCell.h"
#import "ETHealthManager.h"

@interface ETReportPKTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *projectTextField;

@property (weak, nonatomic) IBOutlet UILabel *projectUnitLabel;

@end

@implementation ETReportPKTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.projectNameLabel.textColor = ETTextColor_First;
    self.projectTextField.textColor = ETTextColor_First;
    self.projectUnitLabel.textColor = ETTextColor_Fourth;
    
//    self.projectImageView.layer.cornerRadius = self.projectImageView.jk_height / 2;
//    self.projectImageView.layer.masksToBounds = YES;
    
    @weakify(self)
    [self.projectTextField.rac_textSignal subscribeNext:^(NSString *string) {
        @strongify(self)
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setDictionary:@{@"ProjectID" : self.viewModel.model.ProjectID, @"ReportNum" : string}];
        [self.viewModel.textFiledSubject sendNext:dic];
    }];
    
    [super updateConstraints];
}

- (void)setViewModel:(ETReportPKTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    
    [self.projectNameLabel setText:viewModel.model.ProjectName];
    
    [self.projectUnitLabel setText:viewModel.model.ProjectUnit];
    
    self.projectTextField.text = @"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:@{@"ProjectID" : self.viewModel.model.ProjectID, @"ReportNum" : self.projectTextField.text}];
    [self.viewModel.textFiledSubject sendNext:dic];
    
    if ([viewModel.model.ProjectName isEqualToString:@"健康走"]) {
        self.projectTextField.userInteractionEnabled = NO;
        ETHealthManager *manager = [ETHealthManager sharedInstance];
        @weakify(self)
        [manager authorizeHealthKit:^(BOOL success, NSError *error) {
            if (success) {
                @strongify(self)
                [manager getStepCount:^(double value, NSError *error) {
                    @strongify(self)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.projectTextField.text = [NSString stringWithFormat:@"%.f", value];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setDictionary:@{@"ProjectID" : self.viewModel.model.ProjectID, @"ReportNum" : self.projectTextField.text}];
                        [self.viewModel.textFiledSubject sendNext:dic];
                    });
                }];
            }
        }];
//    } else if ([viewModel.model.ProjectUnit isEqualToString:@"天"]) {
    } else if ([viewModel.model.Limit isEqualToString:@"1"]) {
        self.projectTextField.text = @"1";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setDictionary:@{@"ProjectID" : self.viewModel.model.ProjectID, @"ReportNum" : self.projectTextField.text}];
        [self.viewModel.textFiledSubject sendNext:dic];
        self.projectTextField.userInteractionEnabled = NO;
    } else if ([viewModel.model.ProjectUnit isEqualToString:@"公里"]) {
        self.projectTextField.userInteractionEnabled = YES;
        self.projectTextField.keyboardType = UIKeyboardTypeDecimalPad;
    } else {
        self.projectTextField.userInteractionEnabled = YES;
        self.projectTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
