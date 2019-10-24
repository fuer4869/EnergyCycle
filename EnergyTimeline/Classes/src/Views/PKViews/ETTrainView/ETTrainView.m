//
//  ETTrainView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/19.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainView.h"
#import "ETTrainViewModel.h"

#import "ETWaterWaveView.h"

#import "ETTrainPauseView.h"

#import "ETRestView.h"

#import "ETTrainPopView.h"

#import "ETTrainSetupView.h"

/** 时间格式转换 */
#import "NSString+Time.h"

/** 训练音频播放管理器 */
#import "ETTrainAudioManager.h"

#import "ETTrainAudioDownloadView.h"

static NSString * const pk_train_pause = @"pk_train_pause";
static NSString * const pk_train_setup = @"pk_train_setup";

@interface ETTrainView () <ETTrainPauseViewDelegate, ETTrainPopViewDelegate, ETRestViewDelegate>

@property (nonatomic, strong) UIProgressView *totalProgress; // 训练总进度

@property (nonatomic, strong) UILabel *projectGroup; // 项目名称与组数

@property (nonatomic, strong) UILabel *todayGoalTitle; // 今日目标标题

@property (nonatomic, strong) UILabel *todayTotalGoal; // 今日目标数

@property (nonatomic, strong) UIButton *pauseButton; // 暂停按钮

@property (nonatomic, strong) UILabel *currentGroup; // 当前组

@property (nonatomic, strong) UILabel *encourage; // 鼓励

@property (nonatomic, strong) UILabel *totalTime; // 训练总时间

@property (nonatomic, strong) UIButton *setupButton; // 设置按钮

@property (nonatomic, strong) ETWaterWaveView *waterWaveView; // 水波纹视图

@property (nonatomic, strong) ETTrainViewModel *viewModel;

@end

@implementation ETTrainView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETTrainViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.totalProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
        make.height.equalTo(@(40 + kStatusBarHeight));
    }];
    
    [self.todayTotalGoal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.bottom.equalTo(weakSelf.totalProgress).with.offset(-10);
    }];
    
    [self.projectGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(weakSelf.totalProgress.mas_bottom).with.offset(10);
    }];
    
    [self.todayGoalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(weakSelf.totalProgress.mas_bottom).with.offset(10);
    }];
    
    [self.waterWaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.width.height.equalTo(@160);
    }];
    
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.width.height.equalTo(@160);
    }];
    
    [self.currentGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.pauseButton);
        make.top.equalTo(weakSelf.pauseButton.mas_bottom).with.offset(20);
    }];
    
    [self.encourage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.pauseButton);
        make.top.equalTo(weakSelf.currentGroup.mas_bottom).with.offset(10);
    }];
    
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.bottom.equalTo(@-20);
    }];
    
    [self.setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-20);
    }];
    
    [super updateConstraints];
}

- (void)et_setupViews {
    [self addSubview:self.totalProgress];
    [self addSubview:self.projectGroup];
    [self addSubview:self.todayGoalTitle];
    [self addSubview:self.todayTotalGoal];
    [self addSubview:self.waterWaveView];
    [self addSubview:self.pauseButton];
    [self addSubview:self.currentGroup];
    [self addSubview:self.encourage];
    [self addSubview:self.totalTime];
    [self addSubview:self.setupButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    if (self.viewModel.isContinue) {
        NSLog(@"恢复训练");
    } else {
        NSLog(@"正常训练");
    }
    
    [self.viewModel.trainGetCommand execute:nil];
    
    [self.viewModel.refreshSubject subscribeNext:^(id x) {
        @strongify(self)
        // 控件传值
        self.totalProgress.progress = ([self.viewModel.model.CurrGroupNo floatValue] - 1) / [self.viewModel.model.GroupCount floatValue];
        [self.projectGroup setText:[NSString stringWithFormat:@"%@%@/%@", self.viewModel.model.ProjectName, self.viewModel.model.CurrGroupNo, self.viewModel.model.GroupCount]];
        [self.todayTotalGoal setText:[NSString stringWithFormat:@"%ld", (long)[self.viewModel.model.TargetNum integerValue]]];
        [self.currentGroup setText:[NSString stringWithFormat:@"1/%@", self.viewModel.model.GroupNum]];
        [self.encourage setText:[NSString stringWithFormat:@"%@正在为你加油鼓劲", [self.viewModel.model.SoundType integerValue] == 1 ? @"海哥" : ([self.viewModel.model.SoundType integerValue] == 2 ? @"熊威" : @"尌安")]];
        [self.totalTime setText:[NSString convertMinAndSecWithTime:[self.viewModel.model.Duration integerValue]]];
        self.waterWaveView.progress = 0;
        
        [[ETTrainAudioManager sharedInstance] continuePlaytime:[self.viewModel.model.Duration floatValue]];
        
        // 弹出下载视图
        if (!self.viewModel.ignoreDownload) {
            self.viewModel.ignoreDownload = YES;
            ETTrainAudioDownloadViewModel *downloadViewModel = [[ETTrainAudioDownloadViewModel alloc] init];
            downloadViewModel.startTrainSubject = self.viewModel.startTrainSubject;
            downloadViewModel.backSubject = self.viewModel.backSubject;
            downloadViewModel.model = self.viewModel.model;
            ETTrainAudioDownloadView *downloadView = [[ETTrainAudioDownloadView alloc] initWithViewModel:downloadViewModel];
            [ETWindow addSubview:downloadView];
        }
    }];

    [self.viewModel.startTrainSubject subscribeNext:^(id x) {
        @strongify(self)
        for (NSInteger i = 0; i < [[[ETTrainAudioManager sharedInstance] bgmArr] count]; i ++) {
            if ([self.viewModel.model.BGMFileName isEqualToString:[[ETTrainAudioManager sharedInstance] bgmArr][i]]) {
                [[ETTrainAudioManager sharedInstance] bgmPlayWithBGM:i];
                break;
            }
        }
//        [[ETTrainAudioManager sharedInstance] bgmPlayWithBGM:ETTrainBGMFirst];
        [self.viewModel.continueTrainSubject sendNext:nil];
    }];
    
    [self.viewModel.continueTrainSubject subscribeNext:^(id x) {
        @strongify(self)
        [[ETTrainAudioManager sharedInstance] appendAudioList:self.viewModel.audioPlayList[[self.viewModel.model.CurrGroupNo integerValue] - 1]];
        [[ETTrainAudioManager sharedInstance] startPlay:^(AVQueuePlayer *trainAudioPlayer, CMTime time) {
            [self.totalTime setText:[NSString convertMinAndSecWithTime:(NSInteger)[[ETTrainAudioManager sharedInstance] totalTrainPlayTime]]];
            
            if ([self.viewModel.model.TrainAudioName isEqualToString:[[ETTrainAudioManager sharedInstance] trainPlayAudioFileName]] && [[ETTrainAudioManager sharedInstance] currentTrainPlayTime]) {
                self.waterWaveView.progress = [[ETTrainAudioManager sharedInstance] currentTrainPlayTime] / [[ETTrainAudioManager sharedInstance] currentTrainTotalTime];
                [self.currentGroup setText:[NSString stringWithFormat:@"%ld/%@", (long)(([[ETTrainAudioManager sharedInstance] currentTrainPlayTime] / [self.viewModel.model.Interval integerValue]) + 1), self.viewModel.model.GroupNum]];
            }
            if (self.waterWaveView.progress >= 1.0 && !self.viewModel.isComplete) {
                if ([self.viewModel.model.CurrGroupNo isEqualToString:self.viewModel.model.GroupCount]) {
                    self.viewModel.isComplete = YES;
                    [self.viewModel.trainUpdateCommand execute:nil];
                    NSLog(@"今天训练完成!!!");
                } else if (!self.viewModel.isResting) {
                    NSLog(@"休息");
                    [self.viewModel.restStartSubject sendNext:nil];
                }
            }
        }];
        [[ETTrainAudioManager sharedInstance] trainPlay];
    }];
    
    [self.viewModel.setupSubject subscribeNext:^(id x) {
        @strongify(self)
        ETTrainSetupView *setupView = [[ETTrainSetupView alloc] initWithViewModel:self.viewModel];
        setupView.frame = ETScreenB;
        [ETWindow addSubview:setupView];
    }];
    
    [self.viewModel.restStartSubject subscribeNext:^(id x) {
        @strongify(self)
        if (!self.viewModel.isResting) {
            self.viewModel.isResting = YES;
            // 展示休息浮层
            NSLog(@"休息开始");
            ETRestView *restView = [[ETRestView alloc] initWithViewModel:self.viewModel];
            restView.delegate = self;
            restView.frame = ETScreenB;
            [ETWindow addSubview:restView];
            
            // 更新训练进度,并重新获取数据
            [self.viewModel.trainUpdateCommand execute:nil];
        }
    }];
    
    [self.viewModel.restEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.isResting) {
            self.viewModel.isResting = NO;
            NSLog(@"休息结束");
            [self.viewModel.continueTrainSubject sendNext:nil];
        }
    }];
    
}

#pragma mark -- lazyLoad --

- (UIProgressView *)totalProgress {
    if (!_totalProgress) {
        _totalProgress = [[UIProgressView alloc] init];
        _totalProgress.progressViewStyle = UIProgressViewStyleDefault;
        _totalProgress.progressTintColor = ETMarkYellowColor;
        _totalProgress.trackTintColor = [ETMarkYellowColor colorWithAlphaComponent:0.2];
        _totalProgress.progress = 0.0;
    }
    return _totalProgress;
}

- (UILabel *)projectGroup {
    if (!_projectGroup) {
        _projectGroup = [[UILabel alloc] init];
        _projectGroup.textColor = ETTextColor_Fifth;
        _projectGroup.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        _projectGroup.text = @"-----";
    }
    return _projectGroup;
}

- (UILabel *)todayGoalTitle {
    if (!_todayGoalTitle) {
        _todayGoalTitle = [[UILabel alloc] init];
        _todayGoalTitle.textColor = ETTextColor_Fifth;
        _todayGoalTitle.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        _todayGoalTitle.text = @"今日目标:";
    }
    return _todayGoalTitle;
}

- (UILabel *)todayTotalGoal {
    if (!_todayTotalGoal) {
        _todayTotalGoal = [[UILabel alloc] init];
        _todayTotalGoal.textColor = ETTextColor_Fifth;
        _todayTotalGoal.font = [UIFont fontWithName:@"Arial-BoldMT" size:36];
        _todayTotalGoal.text = @"--";
    }
    return _todayTotalGoal;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc] init];
        [_pauseButton setImage:[UIImage imageNamed:pk_train_pause] forState:UIControlStateNormal];
        @weakify(self)
        [[_pauseButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [[ETTrainAudioManager sharedInstance] trainPause];

            ETTrainPauseView *pauseView = [[ETTrainPauseView alloc] initWithFrame:ETScreenB];
            pauseView.delegate = self;
            [ETWindow addSubview:pauseView];
        }];
    }
    return _pauseButton;
}

- (UILabel *)currentGroup {
    if (!_currentGroup) {
        _currentGroup = [[UILabel alloc] init];
        _currentGroup.textColor = ETTextColor_Fifth;
        _currentGroup.font = [UIFont fontWithName:@"Arial-BoldMT" size:50];
        _currentGroup.text = @"--/--";
    }
    return _currentGroup;
}

- (UILabel *)encourage {
    if (!_encourage) {
        _encourage = [[UILabel alloc] init];
        _encourage.textColor = ETTextColor_Fourth;
        _encourage.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _encourage.text = @"-----";
    }
    return _encourage;
}

- (UILabel *)totalTime {
    if (!_totalTime) {
        _totalTime = [[UILabel alloc] init];
        _totalTime.textColor = ETTextColor_Fourth;
        _totalTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:40];
        _totalTime.text = @"00:00";
    }
    return _totalTime;
}

- (UIButton *)setupButton {
    if (!_setupButton) {
        _setupButton = [[UIButton alloc] init];
        [_setupButton setImage:[UIImage imageNamed:pk_train_setup] forState:UIControlStateNormal];
        @weakify(self)
        [[_setupButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.setupSubject sendNext:nil];
        }];
    }
    return _setupButton;
}

- (ETWaterWaveView *)waterWaveView {
    if (!_waterWaveView) {
        _waterWaveView = [[ETWaterWaveView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        _waterWaveView.backgroundColor = [ETTextColor_Fifth colorWithAlphaComponent:0.6];
        _waterWaveView.isShowSingleWave = YES;
        _waterWaveView.progress = 0.0;
    }
    return _waterWaveView;
}

- (ETTrainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- ETTrainPauseViewDelegate --

/** 暂停界面结束训练按钮方法 */
- (void)trainOver {
    ETTrainPopView *popView = [[ETTrainPopView alloc] initWithTitle:@"提示" Content:@"结束当前训练将无法保存数据和发布动态,确定要结束吗?" LeftBtnTitle:@"结束训练" RightBtnTitle:@"继续训练"];
    popView.delegate = self;
    [ETWindow addSubview:popView];
}

- (void)trainContinue {
    NSLog(@"继续训练");
    [[ETTrainAudioManager sharedInstance] trainPlay];
}

#pragma mark -- ETTrainPopViewDelegate --

- (void)leftButtonClick:(NSString *)string {
    NSLog(@"left - - - %@", string);
    [MobClick event:@"ETTrainOverClick"];
    [self.viewModel.trainEndCommand execute:nil];
}

- (void)rightButtonClick:(NSString *)string {
    NSLog(@"right - - - %@", string);
    [[ETTrainAudioManager sharedInstance] trainPlay];
}

#pragma mark -- ETRestViewDelegate --

- (void)restOver {
//    NSLog(@"休息结束");
    [self.viewModel.restEndSubject sendNext:nil];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
