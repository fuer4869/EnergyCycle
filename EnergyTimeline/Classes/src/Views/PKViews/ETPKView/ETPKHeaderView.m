//
//  ETPKHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKHeaderView.h"
#import "ETPKViewModel.h"
#import "UIColor+GradientColors.h"

#import "AKPickerView.h"
#import "MarqueeView.h"

#import "ETRewardView.h"
#import "ETBadgeView.h"

#import "ETRadioManager.h"

@interface ETPKHeaderView () <AKPickerViewDelegate, AKPickerViewDataSource>

@property (nonatomic, strong) ETPKViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *homePageTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *signinButtton;

@property (weak, nonatomic) IBOutlet UIButton *pkReportButton;

@property (weak, nonatomic) IBOutlet UIView *integralView;

@property (weak, nonatomic) IBOutlet UILabel *integralNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralRankLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralRankChangeLabel;

@property (weak, nonatomic) IBOutlet UIButton *projectRankButton;

@property (nonatomic, strong) MarqueeView *marqueeView;

@property (nonatomic, strong) AKPickerView *pickerView;

@end

@implementation ETPKHeaderView

- (void)updateConstraints {
//    self.backgroundColor = [UIColor colorWithETGradientStyle:ETGradientStyleTopLeftToBottomRight withFrame:CGRectMake(0, 0, ETScreenW, kNavHeight + 10) andColors:@[[UIColor colorWithHexString:@"E05954"], [UIColor colorWithHexString:@"FF6075"]]];
    self.backgroundColor = ETMinorBgColor;
    self.signinButtton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.signinButtton.backgroundColor = [ETTextColor_First colorWithAlphaComponent:0.04];
    self.pkReportButton.backgroundColor = [ETTextColor_First colorWithAlphaComponent:0.04];
    self.signinButtton.layer.cornerRadius = self.signinButtton.jk_height / 2;
    self.pkReportButton.layer.cornerRadius = self.pkReportButton.jk_height / 2;
    
    self.homePageTitleLabel.textColor = [ETTextColor_Fourth colorWithAlphaComponent:0.4];
    self.integralNumberLabel.textColor = ETTextColor_First;
    self.integralRankLabel.textColor = ETTextColor_First;
//    self.integralRankChangeLabel.textColor = ETTextColor_Fourth;
    
//    [self.projectRankButton jk_addTopBorderWithColor:[ETTextColor_Fifth colorWithAlphaComponent:0.5] width:1];
    
//    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.equalTo(weakSelf);
//        make.width.equalTo(@200);
//        make.height.equalTo(@50);
//    }];
    
    WS(weakSelf)
    
    [self.marqueeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.projectRankButton.mas_left).with.offset(-10);
        make.bottom.equalTo(weakSelf).with.offset(-91);
        make.height.equalTo(@28);
        make.width.equalTo(@100);
    }];
    
    [self.pkReportButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.signinButtton.mas_left).with.offset(weakSelf.marqueeView.hidden ? -10 : -28);
        make.centerY.equalTo(weakSelf.marqueeView);
    }];
    
    [self.projectRankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-20);
        make.centerY.equalTo(weakSelf.marqueeView);
    }];
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
//    [self addSubview:self.pickerView];
    [self addSubview:self.marqueeView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
//    [self.pickerView reloadData];
    [self.viewModel.signStatusCommand execute:nil];
    [self.viewModel.myCheckInCommand execute:nil];
    [self.viewModel.myIntegralCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.signinButtton.hidden = self.viewModel.signStatus;
        self.marqueeView.hidden = !self.viewModel.signStatus;
        if ([self.viewModel.myCheckInModel.ContinueDays integerValue] && [self.viewModel.myCheckInModel.CheckInDays integerValue]) {
            self.marqueeView.titleArr = @[[NSString stringWithFormat:@"连续签到%@天", self.viewModel.myCheckInModel.ContinueDays], [NSString stringWithFormat:@"累计签到%@天", self.viewModel.myCheckInModel.CheckInDays]];
        }
        
        // 我的积分详情
        if (self.viewModel.myIntegralModel.AllIntegral && self.viewModel.myIntegralModel.Ranking) {
            self.integralNumberLabel.text = [NSString stringWithFormat:@"积分 %@", self.viewModel.myIntegralModel.AllIntegral];
            self.integralRankLabel.text = [NSString stringWithFormat:@"第%@名", self.viewModel.myIntegralModel.Ranking];
            //        self.integralRankChangeLabel.
            NSString *exceedNum = self.viewModel.myIntegralModel.World;
            if ([exceedNum integerValue] > 0) {
                self.integralRankChangeLabel.text = [NSString stringWithFormat:@"↑%@", exceedNum];
                self.integralRankChangeLabel.textColor = [UIColor jk_colorWithHexString:@"0BC10B"];
                
            } else if ([exceedNum integerValue] == 0) {
                self.integralRankChangeLabel.text = [NSString stringWithFormat:@"--"];
                self.integralRankChangeLabel.textColor = ETTextColor_Fourth;
            } else {
                exceedNum = [exceedNum substringFromIndex:1];
                self.integralRankChangeLabel.text = [NSString stringWithFormat:@"↓%@", exceedNum];
                self.integralRankChangeLabel.textColor = ETRedColor;
            }
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }];
    
}

- (IBAction)sign:(id)sender {
    @weakify(self)
    [[self.viewModel.signCommand execute:nil] subscribeNext:^(id responseObject) {
        @strongify(self)
        [[self.viewModel.signStatusCommand execute:nil] subscribeNext:^(id x) {
//            [[ETRadioManager sharedInstance] playAudioType:ETAudioTypeReportCheckIn];
            
            // 首页签到点击
            [MobClick event:@"ETSignClick"];
            CGFloat duration = 0.f;
            if ([responseObject[@"Data"][@"Integral"] integerValue]) {
                duration = 2.0;
                [ETRewardView rewardViewWithContent:[NSString stringWithFormat:@"+%@积分", responseObject[@"Data"][@"Integral"]] duration:duration audioType:ETAudioTypeReportCheckIn];
            }
            [NSTimer jk_scheduledTimerWithTimeInterval:duration block:^{
                NSMutableArray *models = [NSMutableArray array];
                for (NSDictionary *dic in responseObject[@"Data"][@"_Badge"]) {
                    ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
                    [models addObject:model];
                }
                if (models.count) {
                    [ETBadgeView getBadgeViewWithModels:models];
                }
            } repeats:NO];
        }];
    }];
}

- (IBAction)pkReport:(id)sender {
    // 首页一键汇总点击
    [MobClick event:@"ETReportPKPoolClick"];
    [self.viewModel.pkReportSubject sendNext:nil];
}

- (IBAction)integralRank:(id)sender {
    [self.viewModel.integralRankSubject sendNext:nil];
}

- (IBAction)projectRank:(id)sender {
    [self.viewModel.projectRankSubject sendNext:nil];
}

#pragma mark -- lazyLoad --

- (ETPKViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKViewModel alloc] init];
    }
    return _viewModel;
}

- (AKPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        _pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        _pickerView.textColor = [UIColor colorWithHexString:@"F3F3F3" withAlpha:0.5];
        _pickerView.highlightedTextColor = [UIColor colorWithHexString:@"F3F3F3"];
        _pickerView.interitemSpacing = 20;
        _pickerView.fisheyeFactor = 0.001;
        _pickerView.pickerViewStyle = AKPickerViewStyleFlat;
        _pickerView.maskDisabled = NO;
    }
    return _pickerView;
}

- (MarqueeView *)marqueeView {
    if (!_marqueeView) {
        MarqueeView *marqueeView =[[MarqueeView alloc]initWithFrame:CGRectMake(0, 0, 82, 30) withTitle:@[@"连续签到天数", @"累计签到天数"]];
        marqueeView.layer.cornerRadius = 15;
        marqueeView.titleColor = [UIColor colorWithHexString:@"FF7C79"];
        marqueeView.titleFont = [UIFont boldSystemFontOfSize:12];
        marqueeView.backgroundColor = [ETTextColor_First colorWithAlphaComponent:0.04];
        marqueeView.hidden = YES;
//        __weak MarqueeView *marquee = marqueeView;
        marqueeView.handlerTitleClickCallBack = ^(NSInteger index){
            
            [self.viewModel.myCheckInClickSubject sendNext:nil];
        };
        _marqueeView = marqueeView;
    }
    return _marqueeView;
}

#pragma mark -- AKPickerViewDelegate And AKPickerViewDataScouce --

//- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
//    return 6;
//}
//
//- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item {
//    NSArray *array = @[@"器械锻炼", @"坐姿臂屈伸", @"健康走", @"阅读", @"坐姿收腹举腿", @"深蹲"];
//    return array[item];
//}
//
//- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
//    NSLog(@"%d", item);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
