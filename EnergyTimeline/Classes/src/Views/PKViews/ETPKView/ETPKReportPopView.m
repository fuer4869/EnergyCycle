//
//  ETPKReportPopView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKReportPopView.h"
#import "ETRewardView.h"
#import "ETBadgeView.h"

#import "ETPKProjectAlarmVC.h"
#import "ETReportPostVC.h"
#import "ETReportPostNavController.h"

static NSString * const defaultTextColor = @"262626";

static NSString * const hintTextColor = @"9A9A9A";

static NSString * const alarmTitleColor = @"444E43";

static NSString * const lineColor = @"E3E7EB";

static NSString * const reportBackgroundColor = @"E05954";

@interface ETPKReportPopView ()

@property (nonatomic, strong) UIButton *shadowButton;

@property (nonatomic, strong) UIView *popView;

@property (nonatomic, strong) UIImageView *projectImageView;

@property (nonatomic, strong) UILabel *projectNameLabel;

@property (nonatomic, strong) UIButton *alarmButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *projectUnitLabel;

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) UIButton *reportButton;

@end

@implementation ETPKReportPopView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.shadowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@35);
        make.right.equalTo(@-35);
//        make.top.equalTo(weakSelf.shadowButton).with.offset(ETScreenH * 0.4);
        make.centerY.equalTo(weakSelf.shadowButton);
        make.height.equalTo(@(250));
    }];
    
    [self.projectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.width.height.equalTo(@40);
    }];
    
    [self.projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.projectImageView);
        make.left.equalTo(weakSelf.projectImageView.mas_right).with.offset(@10);
    }];
    
    [self.alarmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.popView);
        make.centerY.equalTo(weakSelf.projectImageView);
        make.height.equalTo(60);
        make.width.equalTo(60);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.popView);
        make.top.equalTo(@60);
        make.height.equalTo(@1);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineView.mas_bottom).with.offset(40);
        make.centerX.equalTo(weakSelf);
        make.height.equalTo(@40);
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
    }];
    
    [self.projectUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.textField);
        make.left.equalTo(weakSelf.textField.mas_right);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textField.mas_bottom).with.offset(22);
        make.centerX.equalTo(weakSelf.textField);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.popView);
        make.height.equalTo(@60);
    }];
    
    [super updateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKReportPopViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.shadowButton];
    [self.shadowButton addSubview:self.popView];
    [self.popView addSubview:self.projectImageView];
    [self.popView addSubview:self.projectNameLabel];
    [self.popView addSubview:self.alarmButton];
    [self.popView addSubview:self.lineView];
    [self.popView addSubview:self.textField];
    [self.popView addSubview:self.projectUnitLabel];
    [self.popView addSubview:self.hintLabel];
    [self.popView addSubview:self.reportButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

- (void)et_bindViewModel {
    @weakify(self)
    
//    [self.viewModel.textFieldSubject subscribeNext:^(NSMutableDictionary *dic) {
//        @strongify(self)
////        BOOL lack = [dic[@"ReportNum"] isEqualToString:@""];
//        self.reportButton.enabled = ![dic[@"ReportNum"] isEqualToString:@""];
//    }];
    
    [self.textField.rac_textSignal subscribeNext:^(NSString *string) {
        @strongify(self)
        [self.viewModel.projectNumArray removeAllObjects];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setDictionary:@{@"ProjectID" : self.viewModel.model.ProjectID ? self.viewModel.model.ProjectID : @"", @"ReportNum" : string}];
//        [self.viewModel.textFieldSubject sendNext:dic];
        self.reportButton.enabled = ![string isEqualToString:@""];
        self.reportButton.backgroundColor = [string isEqualToString:@""] ? ETGrayColor : [UIColor jk_colorWithHexString:reportBackgroundColor];
        [self.viewModel.projectNumArray addObject:dic];

    }];
    
    [self.viewModel.reportCompletedSubject subscribeNext:^(id responseObject) {
        @strongify(self)
        NSMutableArray *badgeModels = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Data"][@"_Badge"]) {
            ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
            [badgeModels addObject:model];
        }
        NSMutableArray *praiseModels = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"Data"][@"_Praise"]) {
            ETPraiseModel *model = [[ETPraiseModel alloc] initWithDictionary:dic error:nil];
            [praiseModels addObject:model];
        }
        CGFloat duration = 0.f;
        if ([responseObject[@"Data"][@"Integral"] integerValue]) {
            duration = 2.0;
            NSString *content = [NSString stringWithFormat:@"%@积分", responseObject[@"Data"][@"Integral"]];
            NSString *extra = [NSString stringWithFormat:@"恭喜你，额外获得了%@积分", responseObject[@"Data"][@"RewardIntegral"]];
            if (badgeModels.count || praiseModels.count) {
                if ([responseObject[@"Data"][@"RewardIntegral"] integerValue]) {
                    duration += 1;
                    [ETRewardView rewardViewWithContent:content extra:extra duration:duration audioType:ETAudioTypeGetBadge];
                } else {
                    [ETRewardView rewardViewWithContent:content duration:duration audioType:ETAudioTypeGetBadge];
                }
            } else {
                if ([responseObject[@"Data"][@"RewardIntegral"] integerValue]) {
                    duration += 1;
                    [ETRewardView rewardViewWithContent:content extra:extra duration:duration audioType:ETAudioTypeReportPK];
                } else {
                    [ETRewardView rewardViewWithContent:content duration:duration audioType:ETAudioTypeReportPK];
                }
            }
        }
        [NSTimer jk_scheduledTimerWithTimeInterval:duration block:^{
            if (praiseModels.count) {
                [ETBadgeView getPraiseViewWithModels:praiseModels];
            }
            if (badgeModels.count) {
                [ETBadgeView getBadgeViewWithModels:badgeModels];
            }
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:1.0
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 self.alpha = 0;
                             } completion:^(BOOL finished) {
                                 ETReportPostVC *postVC = [[ETReportPostVC alloc] init];
                                 ETReportPostNavController *postNavVC = [[ETReportPostNavController alloc] initWithRootViewController:postVC];
                                 [ETWindow.rootViewController presentViewController:postNavVC animated:YES completion:nil];
                                 [self removeFromSuperview];
                             }];
        } repeats:NO];
    }];
}

- (void)setModel:(ETDailyPKProjectRankListModel *)model {
    if (!model) {
        return;
    }
    _viewModel.model = model;
    _model = model;

    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
    self.projectNameLabel.text = model.ProjectName;
    if ([model.ProjectName isEqualToString:@"早起"]) {
//        self.textField.text = [NSString stringWithFormat:@"%ld : %ld", [[NSDate date] jk_hour], [[NSDate date] jk_minute]];
        NSDate *date = [NSDate date];
        self.textField.text = [NSDate jk_stringWithDate:date format:@"HH : mm"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:a"];
        NSString *ampm = [[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@":"] objectAtIndex:2];
        self.projectUnitLabel.text = ampm;
        self.hintLabel.hidden = NO;
        
        [self.viewModel.projectNumArray removeAllObjects];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setDictionary:@{@"ProjectID" : model.ProjectID ? self.viewModel.model.ProjectID : @"", @"ReportNum" : @"1"}];
        self.reportButton.enabled = YES;
        self.reportButton.backgroundColor = [UIColor jk_colorWithHexString:reportBackgroundColor];
        [self.viewModel.projectNumArray addObject:dic];
        self.textField.userInteractionEnabled = NO;
    } else  if ([model.ProjectUnit isEqualToString:@"天"]){
        self.textField.enabled = NO;
        self.textField.text = @"1";
        self.projectUnitLabel.text = model.ProjectUnit;
        self.hintLabel.hidden = YES;
        [self.viewModel.projectNumArray removeAllObjects];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setDictionary:@{@"ProjectID" : model.ProjectID ? self.viewModel.model.ProjectID : @"", @"ReportNum" : @"1"}];
        self.reportButton.enabled = YES;
        self.reportButton.backgroundColor = [UIColor jk_colorWithHexString:reportBackgroundColor];
        [self.viewModel.projectNumArray addObject:dic];
        self.textField.userInteractionEnabled = NO;
    } else {
        self.textField.userInteractionEnabled = YES;
        self.textField.enabled = YES;
//        [self.textField becomeFirstResponder];
        // 过1秒后弹出键盘,否则用户不知道哪里可以编辑
        [NSTimer jk_scheduledTimerWithTimeInterval:1.0 block:^{
            [self.textField becomeFirstResponder];
        } repeats:NO];
        self.projectUnitLabel.text = model.ProjectUnit;
        self.hintLabel.hidden = YES;
    }
}

#pragma mark -- lazyLoad --

- (UIButton *)shadowButton {
    if (!_shadowButton) {
        _shadowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shadowButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _shadowButton.adjustsImageWhenHighlighted = NO; // 取消高亮
        @weakify(self)
        [[_shadowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self removeFromSuperview];
        }];
    }
    return _shadowButton;
}

- (UIView *)popView {
    if (!_popView) {
        _popView = [[UIView alloc] init];
        _popView.backgroundColor = [UIColor whiteColor];
        _popView.layer.cornerRadius = 10;
    }
    return _popView;
}

- (UIImageView *)projectImageView {
    if (!_projectImageView) {
        _projectImageView = [[UIImageView alloc] init];
        _projectImageView.layer.cornerRadius = 20;
        _projectImageView.layer.masksToBounds = YES;
    }
    return _projectImageView;
}

- (UILabel *)projectNameLabel {
    if (!_projectNameLabel) {
        _projectNameLabel = [[UILabel alloc] init];
        _projectNameLabel.font = [UIFont systemFontOfSize:12];
        _projectNameLabel.textColor = [UIColor jk_colorWithHexString:defaultTextColor];
    }
    return _projectNameLabel;
}

- (UIButton *)alarmButton {
    if (!_alarmButton) {
        _alarmButton = [[UIButton alloc] init];
        [_alarmButton setImage:[UIImage imageNamed:@"pk_alarm_red"] forState:UIControlStateNormal];
//        [_alarmButton setTitle:@"创建闹钟" forState:UIControlStateNormal];
//        [_alarmButton setTitleColor:[UIColor jk_colorWithHexString:alarmTitleColor] forState:UIControlStateNormal];
        [_alarmButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [[_alarmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self removeFromSuperview];
            ETPKProjectAlarmVC *alarmVC = [[ETPKProjectAlarmVC alloc] init];
            alarmVC.viewModel.projectModel = self.viewModel.model;
            UINavigationController *alarmNavVC = [[UINavigationController alloc] initWithRootViewController:alarmVC];
            [ETWindow.rootViewController presentViewController:alarmNavVC animated:YES completion:nil];
        }];
    }
    return _alarmButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor jk_colorWithHexString:lineColor];
    }
    return _lineView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:30 weight:UIFontWeightSemibold];
        _textField.textAlignment = NSTextAlignmentCenter;
        [_textField setTintColor:[UIColor blackColor]];
        _textField.userInteractionEnabled = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;

    }
    return _textField;
}

- (UILabel *)projectUnitLabel {
    if (!_projectUnitLabel) {
        _projectUnitLabel = [[UILabel alloc] init];
        _projectUnitLabel.font = [UIFont systemFontOfSize:14];
        _projectUnitLabel.textColor = [UIColor jk_colorWithHexString:defaultTextColor];
    }
    return _projectUnitLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:10];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = @"5:00~7:00 AM为早起时间";
        _hintLabel.textColor = [UIColor jk_colorWithHexString:hintTextColor];
    }
    return _hintLabel;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        _reportButton.backgroundColor = [UIColor jk_colorWithHexString:reportBackgroundColor];
        _reportButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_reportButton setTitle:@"打卡" forState:UIControlStateNormal];
        [_reportButton setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        _reportButton.titleLabel.font = [UIFont systemFontOfSize:14];
        @weakify(self)
        [[_reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            // 点击汇报项目
            [MobClick event:@"ETPKReportPopView_ReportClick" attributes:@{@"ProjectName" : self.viewModel.model.ProjectName}];
            [self.viewModel.reportCommand execute:nil];
        }];
    }
    return _reportButton;
}

- (ETPKReportPopViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKReportPopViewModel alloc] init];
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
