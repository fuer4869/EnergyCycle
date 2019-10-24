//
//  SinglePromiseDetailsVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/3/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "SinglePromiseDetailsVC.h"
#import "FSCalendar.h"
#import "CalendarCell.h"
#import "Masonry.h"
#import "PromiseModel.h"
#import "CalendarDayModel.h"

#import "PK_Target_Details_Get_Request.h"
#import "PK_Target_Del_Request.h"

@interface SinglePromiseDetailsVC ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance> {
    BOOL sure;
    UIView *hintView;
    UILabel *titleLabel; // 项目名称
    UILabel *durationLabel; // 目标时长
    UILabel *promiseLabel; // 每日目标
    UILabel *finishTimeLabel; // 目标完成小计
    UILabel *finishPercentage; // 完成进度百分比
    UIView *percentageView; // 完成进度条
    
}

@property (nonatomic, strong) UIButton *exitBackground;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, weak) FSCalendar *calendar;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSMutableDictionary *dates;

@end

@implementation SinglePromiseDetailsVC

- (NSMutableDictionary *)dates {
    if (!_dates) {
        self.dates = [NSMutableDictionary dictionary];
    }
    return _dates;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)et_layoutNavigation {
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithimage:@"promise_del_red"];
    self.view.backgroundColor = ETMainBgColor;
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)createHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ETScreenW, 180);
//    headerView.backgroundColor = [UIColor whiteColor];
    headerView.backgroundColor = ETMinorBgColor;
    [self.view addSubview:headerView];
    
    titleLabel = [UILabel new];
//    [titleLabel setText:self.model.ProjectName];
    [titleLabel setText:@"--"];
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
    [titleLabel setTextColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1]];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.centerX.equalTo(headerView);
    }];
    
    UILabel *durationTitle = [UILabel new];
    [durationTitle setText:@"目标时长"];
    durationTitle.textAlignment = NSTextAlignmentCenter;
    [durationTitle setFont:[UIFont systemFontOfSize:12]];
    [headerView addSubview:durationTitle];
    [durationTitle setTextColor:ETTextColor_Third];
    [durationTitle setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [durationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@60);
        make.top.equalTo(@75);
    }];
    
    durationLabel = [UILabel new];
//    [durationLabel setText:[NSString stringWithFormat:@"%@天", self.model.AllDays]];
    [durationLabel setText:@"-天"];
    [durationLabel setFont:[UIFont systemFontOfSize:15]];
//    [durationLabel setTextColor:[UIColor blackColor]];
    [durationLabel setTextColor:ETTextColor_First];
    [headerView addSubview:durationLabel];
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(durationTitle.mas_top).with.offset(20);
        make.centerX.equalTo(durationTitle);
    }];
    
    UILabel *promiseTitle = [UILabel new];
    [promiseTitle setText:@"每日目标"];
    [promiseTitle setFont:[UIFont systemFontOfSize:12]];
//    [promiseTitle setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [promiseTitle setTextColor:ETTextColor_Third];
    [headerView addSubview:promiseTitle];
    [promiseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-60);
        make.top.equalTo(@75);
    }];
    
    promiseLabel = [UILabel new];
//    [promiseLabel setText:[NSString stringWithFormat:@"%@%@", self.model.ReportNum, self.model.P_UNIT]];
    [promiseLabel setText:@"--"];
    [promiseLabel setFont:[UIFont systemFontOfSize:15]];
//    [promiseLabel setTextColor:[UIColor blackColor]];
    [promiseLabel setTextColor:ETTextColor_First];
    [headerView addSubview:promiseLabel];
    [promiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promiseTitle.mas_top).with.offset(20);
        make.centerX.equalTo(promiseTitle);
    }];
    
    if ([self.model.ProjectUnit isEqualToString:@"天"]) {
        [durationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titleLabel);
            make.top.equalTo(@75);
        }];
        promiseTitle.hidden = YES;
        promiseLabel.hidden = YES;
    }
    
    
    finishTimeLabel = [UILabel new];
    [finishTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [finishTimeLabel setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [headerView addSubview:finishTimeLabel];
    [finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(durationLabel.mas_bottom).with.offset(15);
    }];
    
    UILabel *finishLabel = [UILabel new];
    [finishLabel setText:@"完成"];
    [finishLabel setFont:[UIFont systemFontOfSize:12]];
    [finishLabel setTextColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]];
    [headerView addSubview:finishLabel];
    [finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-55);
        make.top.equalTo(promiseLabel.mas_bottom).with.offset(15);
    }];
    
    // 完成进度
//    CGFloat modulus = [self.model.FinishDays floatValue] / [self.model.AllDays floatValue];

    finishPercentage = [UILabel new];
//    [finishPercentage setText:[NSString stringWithFormat:@"%.f%%", modulus * 100]];
    [finishPercentage setText:@"0%"];
    [finishPercentage setFont:[UIFont systemFontOfSize:12]];
//    [finishPercentage setTextColor:[UIColor blackColor]];
    [finishPercentage setTextColor:ETTextColor_First];
    [headerView addSubview:finishPercentage];
    [finishPercentage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(promiseLabel.mas_bottom).with.offset(15);
    }];
    
    percentageView = [UIView new];
    [percentageView setBackgroundColor:[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:0.3]];
    [headerView addSubview:percentageView];
    [percentageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.width.equalTo(@(ETScreenW - 30));
        make.height.equalTo(@7);
        make.bottom.equalTo(@-20);
    }];
    percentageView.layer.cornerRadius = 7 / 2;
}

- (void)addHeaderViewData {
    [titleLabel setText:self.model.ProjectName];
    [durationLabel setText:[NSString stringWithFormat:@"%@天", self.model.TotalDays]];
    [promiseLabel setText:[NSString stringWithFormat:@"%@%@", self.model.ReportNum, self.model.ProjectUnit]];
    
    // 根据目标开始时间进行显示判断
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate = [formatter dateFromString:self.model.StartDate];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval startDateInterval = [startDate timeIntervalSince1970]; // 开始时间的时间间隔
    NSTimeInterval nowDateInterval = [nowDate timeIntervalSince1970]; // 现在时间的时间间隔
    if (startDateInterval > nowDateInterval) {
        formatter.dateFormat = @"MM/dd";
        NSString *startDate_str = [formatter stringFromDate:startDate];
        NSMutableAttributedString *startText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"目标将于%@开始", startDate_str]];
        NSRange range = NSMakeRange(4, startDate_str.length);
        [startText addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: ETTextColor_First} range:range];
        [finishTimeLabel setAttributedText:startText];
    } else {
        NSRange range = NSMakeRange(5, self.model.FinishDays.length + self.model.TotalDays.length + 1);
        NSMutableAttributedString *startText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"完成目标第%ld/%ld天", (long)[self.model.FinishDays integerValue], (long)[self.model.TotalDays integerValue]]];
        [startText addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: ETTextColor_First} range:range];
        finishTimeLabel.attributedText = startText;
    }
    
    CGFloat modulus = [self.model.FinishDays floatValue] / [self.model.TotalDays floatValue];

    [finishPercentage setText:[NSString stringWithFormat:@"%.f%%", modulus * 100]];
    
    CALayer *percentageLayer = [CALayer layer];
    CGFloat percentage = (ETScreenW - 30) * modulus;
    percentageLayer.frame = CGRectMake(0.0f, 0.0f, percentage, 7);
    percentageLayer.cornerRadius = 7 / 2;
    percentageLayer.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    percentageLayer.shadowColor = percentageLayer.backgroundColor;
    percentageLayer.shadowOpacity = 0.5;
    percentageLayer.shadowOffset = CGSizeMake(2, 2);
    [percentageView.layer addSublayer:percentageLayer];
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view.backgroundColor = ETMinorBgColor;
    self.view = view;
    
    [self createHeaderView];

    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 180, view.frame.size.width, 300)];
    calendar.scope = FSCalendarScopeWeek;
    calendar.dataSource = self;
    calendar.delegate = self;
//    calendar.backgroundColor = [UIColor whiteColor];
    calendar.backgroundColor = ETMinorBgColor;
    
    // 星期的view下面添加底部边框
    CALayer *headerView_bottomBorder = [CALayer layer];
    CGFloat h_y = 25;
    CGFloat h_w = view.frame.size.width;
    headerView_bottomBorder.frame = CGRectMake(0.0f, h_y, h_w, 1.0f);
    headerView_bottomBorder.backgroundColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:0.6].CGColor;
    [calendar.calendarWeekdayView.layer addSublayer:headerView_bottomBorder];
    
    [calendar selectDate:[NSDate date] scrollToDate:YES]; // 默认选择今天
    calendar.today = nil; // 隐藏今天的背景
    calendar.appearance.titleSelectionColor = [UIColor colorWithRed:255/255.0 green:225/255.0 blue:20/255.0 alpha:1]; // 选中时文字的颜色
    calendar.appearance.selectionColor = [UIColor clearColor]; // 去除选中时的背景颜色
    calendar.appearance.weekdayTextColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1]; // 日的字体颜色
    calendar.appearance.titleDefaultColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1]; // 星期的字体颜色
    calendar.headerHeight = 0; // 顶部月份隐藏
    calendar.appearance.headerTitleColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1]; // 顶部月份文字颜色
    calendar.appearance.headerDateFormat = @"yyyy-MM"; // 顶部月份显示格式
    calendar.appearance.headerMinimumDissolvedAlpha = 0; // 顶部上下月份显示的透明度
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase; // 修改星期显示文字
    
    // 给calendar底部添加阴影
//    CALayer *calendar_bottomBorder = [CALayer layer];
//    CGFloat c_y = calendar.frame.size.height;
//    CGFloat c_w = calendar.frame.size.width;
//    calendar_bottomBorder.frame = CGRectMake(0.0f, c_y, c_w, 1.0f);
//    calendar_bottomBorder.backgroundColor = [UIColor clearColor].CGColor;
//    [calendar.layer addSublayer:calendar_bottomBorder];
//    calendar.layer.shadowOpacity = 0.2;
//    calendar.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
//    calendar.layer.shadowOffset = CGSizeMake(0, 4);
//    calendar.layer.shadowRadius = 3;
    [calendar registerClass:[CalendarCell class] forCellReuseIdentifier:@"cell"]; // 注册CalendarCell
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
}

// 获取数据
- (void)getData {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    PK_Target_Details_Get_Request *detailsRequest = [[PK_Target_Details_Get_Request alloc] initWithTargetID:self.targetID];
    [detailsRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
        if ([request.responseObject[@"Status"] integerValue] == 200) {
            NSDictionary *target = request.responseObject[@"Data"][@"Target_List"];
            NSDictionary *targetDetails = request.responseObject[@"Data"][@"Target_Deials_List"];
            for (NSDictionary *dic in target) {
                PromiseModel *model = [[PromiseModel alloc] initWithDictionary:dic error:nil];
                self.model = model;
            }
            
            for (NSDictionary *dic in targetDetails) {
                CalendarDayModel *model = [[CalendarDayModel alloc] initWithDictionary:dic error:nil];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *reportDate = [formatter dateFromString:model.ReportDate];
                formatter.dateFormat = @"yyyy-MM-dd";
                NSString *reportDate_str = [formatter stringFromDate:reportDate];
                [self.dates setObject:model.Is_Finish forKey:reportDate_str];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addHeaderViewData];
                [self.calendar reloadData];
            });
        }
    } failure:^(__kindof ETBaseRequest * _Nonnull request) {
        NSLog(@"%@", request.responseObject);
    }];
    
//    [[AppHttpManager shareInstance] getTargetDetailsWithTargetID:self.targetID PostOrGet:@"get" success:^(NSDictionary *dict) {
//        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
//            NSDictionary *target = dict[@"Data"][@"Target"];
//            NSDictionary *targetDetails = dict[@"Data"][@"TargetDetails"];
//            for (NSDictionary *dic in target) {
//                PromiseModel *model = [[PromiseModel alloc] initWithDictionary:dic error:nil];
//                self.model = model;
//            }
//            
//            for (NSDictionary *dic in targetDetails) {
//                CalendarDayModel *model = [[CalendarDayModel alloc] initWithDictionary:dic error:nil];
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//                NSDate *reportDate = [formatter dateFromString:model.ReportDate];
//                formatter.dateFormat = @"yyyy-MM-dd";
//                NSString *reportDate_str = [formatter stringFromDate:reportDate];
//                [self.dates setObject:model.IsFinish forKey:reportDate_str];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self addHeaderViewData];
//                [self.calendar reloadData];
//            });
//            
//        }
//    } failure:^(NSString *str) {
//        NSLog(@"%@", str);
//    }];
    
}

// 当前月份的行数变化时日历控件的高度也随之变化
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    
    // 底部阴影浮层
    self.exitBackground = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitBackground.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.exitBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.exitBackground.alpha = 0;
    [self.exitBackground addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.exitBackground];
    
    // 创建底部View
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ETScreenH, ETScreenW, 130)];
    [self.exitBackground addSubview:self.bottomView];
    
    // 退出目标按钮
    UIButton *exitPromise = [UIButton new];
    [exitPromise setTitle:@"退出目标" forState:UIControlStateNormal];
    [exitPromise setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [exitPromise setBackgroundColor:[UIColor whiteColor]];
    [exitPromise addTarget:self action:@selector(showHintView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:exitPromise];
    [exitPromise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView.mas_width).with.offset(-20);
        make.height.equalTo(@50);
        make.top.equalTo(@10);
    }];
    exitPromise.layer.shadowColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1].CGColor;
    exitPromise.layer.shadowOpacity = 0.3;
    exitPromise.layer.shadowRadius = 3;
    exitPromise.layer.shadowOffset = CGSizeMake(0, 0);
    
    // 取消按钮
    UIButton *cancelButton = [UIButton new];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView.mas_width).with.offset(-20);
        make.height.equalTo(@50);
        make.top.equalTo(exitPromise.mas_bottom).with.offset(10);
    }];
    
    hintView = [[UIView alloc] init];
    hintView.backgroundColor = [UIColor whiteColor];
    hintView.hidden = YES;
    [self.exitBackground addSubview:hintView];
    [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.exitBackground);
        make.centerY.equalTo(self.exitBackground);
        make.width.equalTo(self.exitBackground).multipliedBy(0.6);
        make.height.equalTo(@150);
    }];
    hintView.layer.cornerRadius = 20;
    hintView.layer.shadowColor = [UIColor blackColor].CGColor;
    hintView.layer.shadowOpacity = 0.2;
    hintView.layer.shadowRadius = 3;
    hintView.layer.shadowOffset = CGSizeMake(0, 0);
    
    UILabel *hintLabel = [[UILabel alloc] init];
    [hintLabel setText:@"确定要退出目标么\n退出将扣除100积分作为惩罚"];
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.numberOfLines = 0;
    [hintView addSubview:hintLabel];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hintView).with.offset(-20);
        make.centerX.equalTo(hintView);
        make.width.equalTo(hintView).multipliedBy(0.75);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    [hintView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(hintView).with.offset(-40);
        make.left.equalTo(hintView);
        make.right.equalTo(hintView);
        make.height.equalTo(@1);
    }];
    
    UIButton *exit = [UIButton new];
    exit.adjustsImageWhenHighlighted = NO;
    [exit setTitle:@"确认" forState:UIControlStateNormal];
    [exit setTitleColor:[UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1] forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(exitPromise) forControlEvents:UIControlEventTouchUpInside];
    [hintView addSubview:exit];
    [exit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).with.offset(5);
        make.width.equalTo(hintView);
        make.centerX.equalTo(hintView);
    }];
    
    CGPoint addPoint = self.bottomView.center;
    addPoint.y -= self.bottomView.frame.size.height;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.bottomView.center = addPoint;
                         self.exitBackground.alpha = 1;
    } completion:nil];
    
}

- (void)showHintView {
    
    if (self.exitBackground) {
        sure = YES;
        CGPoint cancelPoint = self.bottomView.center;
        cancelPoint.y += self.bottomView.frame.size.height;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.bottomView.center = cancelPoint;
            hintView.hidden = NO;
        } completion:nil];
    }
    
}

- (void)cancel {
    CGPoint cancelPoint = self.bottomView.center;
    cancelPoint.y += self.bottomView.frame.size.height;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomView.center = cancelPoint;
        self.exitBackground.alpha = 0;
    } completion:^(BOOL finished) {
        [self.exitBackground removeFromSuperview];
    }];
}

// 退出目标
- (void)exitPromise {
    if (sure) {
        sure = NO;
        
        PK_Target_Del_Request *delRequest = [[PK_Target_Del_Request alloc] initWithTargetID:[self.model.TargetID integerValue]];
        [delRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
            if ([request.responseObject[@"Status"] integerValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self cancel];
                    [self leftAction];
                });
            }
        } failure:^(__kindof ETBaseRequest * _Nonnull request) {
            NSLog(@"%@", request.responseObject);
        }];
        
//        [[AppHttpManager shareInstance] getTargetDelWithUserID:[User_ID integerValue] Token:User_TOKEN TargetID:[self.model.TargetID integerValue]PostOrGet:@"post" success:^(NSDictionary *dict) {
//            if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self cancel];
//                    [self leftAction];
//                });
//            }
//        } failure:^(NSString *str) {
//            NSLog(@"%@", str);
//        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"目标详情";
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSCalendarDataSourse

// 返回自定义cell方法
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position {
    CalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:position];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

// 设置每个选中的日期的文字颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    NSString *key = [self.dateFormatter stringFromDate:date];
    if ([self.dates.allKeys containsObject:key]) {
        return [UIColor whiteColor];
    }
    return nil;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

// 点击方法
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

// 取消点击方法
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

#pragma mark - Private methods

// 重新配置cell的方法
- (void)configureVisibleCells {
    
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
    
}

// 设置自定义的cell方法
- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    CalendarCell *calendarCell = (CalendarCell *)cell;
    
    if (monthPosition == FSCalendarMonthPositionCurrent) {
        
        SelectionType selectionType = SelectionTypeNone;
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
        NSDate *date_jetLag = [date dateByAddingTimeInterval:interval];
        NSString *key = [self.dateFormatter stringFromDate:date_jetLag];
        if ([self.dates.allKeys containsObject:key]) {
            if ([self.dates[key] isEqualToString:@"1"]) {
                selectionType = SelectionTypeFinish;
            } else {
                selectionType = SelectionTypeUndone;
            }
        } else {
            selectionType = SelectionTypeNone;
        }
        
        calendarCell.selectionType = selectionType;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
