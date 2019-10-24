//
//  PromiseVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2017/2/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PromiseVC.h"
#import "AddPromiseViewCell.h"
#import "PromiseOngoingViewCell.h"
#import "ETRefreshGifHeader.h"
#import "PromiseDetailsVC.h"
//#import "ProjectVC.h"
#import "ETSearchProjectVC.h"
#import "SinglePromiseDetailsVC.h"
#import "HistoryPromiseVC.h"
//#import "PKGatherViewController.h"
#import "RightNavMenuView.h"
#import "PromiseModel.h"
#import "PromiseDetailModel.h"

#import "PK_My_Target_List_Request.h"

#import "ETHomePageVC.h"

#define kCalendar_HeaderHeight 80

@interface PromiseVC ()<UITableViewDelegate, UITableViewDataSource, RightNavMenuViewDelegate> {
    NSInteger pageIndex;
    NSInteger pageSize;
}

@property (nonatomic, strong) RightNavMenuView *rightNavMenuView; // 右侧菜单栏

@property (nonatomic, strong) NSMutableArray *menuDataArray; // 菜单栏内容

@property (nonatomic, strong) NSMutableArray *dataArray; // 目标列表数据

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PromiseDetailsVC *promiseDetailsVC;

@property (nonatomic, strong) UIButton *explanation;

@property (nonatomic, strong) UIButton *navMenuBackground;

@end

@implementation PromiseVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)menuDataArray {
    if (!_menuDataArray) {
        self.menuDataArray = [NSMutableArray array];
    }
    return _menuDataArray;
}

- (void)et_getNewData {
    PK_My_Target_List_Request *myTargetRequest = [[PK_My_Target_List_Request alloc] initWithType:1 PageIndex:1 PageSize:100];
    [myTargetRequest startWithCompletionBlockWithSuccess:^(__kindof ETBaseRequest * _Nonnull request) {
        if ([request.responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", request.responseObject);
            if ([self.dataArray count]) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in request.responseObject[@"Data"]) {
                PromiseModel *model =[[PromiseModel alloc] initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(__kindof ETBaseRequest * _Nonnull request) {
        NSLog(@"%@", request.responseObject);
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETPromiseVC"];

    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithimage:@"more_circle_red"];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singlePromise:) name:@"PushSinglePromiseDetailsVC" object:nil];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETPromiseVC"];
    [self resetNavigation];
}

- (void)singlePromise:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    PromiseModel *model = dic[@"Model"];
    SinglePromiseDetailsVC *spdVC = [[SinglePromiseDetailsVC alloc] init];
    spdVC.targetID = [model.TargetID integerValue];
    spdVC.model = model;
    [self.navigationController pushViewController:spdVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeNavMenuView];
}

- (void)leftAction {
    CGFloat top = self.view.bounds.origin.y;
    CGFloat pdVC_y = self.promiseDetailsVC.view.frame.origin.y;
    if (pdVC_y == top) {
        [self changeControllerRect];
    } else {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightAction {
    
    // 顶部导航栏右侧菜单
    if (!self.navMenuBackground) {
        self.navMenuBackground = [UIButton buttonWithType:UIButtonTypeCustom];
        self.navMenuBackground.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.navMenuBackground.backgroundColor = [UIColor clearColor];
        [self.navMenuBackground addTarget:self action:@selector(removeNavMenuView) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:self.navMenuBackground];
        
        self.rightNavMenuView = [[RightNavMenuView alloc] initWithDataArray:self.menuDataArray];
        [self.navMenuBackground addSubview:self.rightNavMenuView];
        self.rightNavMenuView.delegate = self;
        [self.rightNavMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@60);
            make.right.equalTo(self.navMenuBackground.mas_right).with.offset(-10);
            make.width.equalTo(@115);
            make.height.equalTo(@(self.menuDataArray.count * 40 + 25));
        }];
    } else {
        [self removeNavMenuView];
    }

}

// 清楚顶部菜单栏
- (void)removeNavMenuView {
    [self.navMenuBackground removeFromSuperview];
    self.navMenuBackground = nil;
}

// 创建目标列表
- (void)createTableView {
    
    CGRect rect = self.view.bounds;
    rect.size.height -= kNavHeight + kCalendar_HeaderHeight - 15;
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 20)];
//    self.tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    self.tableView.backgroundColor = ETMainBgColor;
    [self.view addSubview:self.tableView];
    
}

// 创建日历视图控制器
- (void)createCalendar {
    
    self.promiseDetailsVC = [[PromiseDetailsVC alloc] init];
    CGFloat pdVC_y = CGRectGetMaxY(self.tableView.frame);
    self.promiseDetailsVC.view.frame = CGRectMake(0, pdVC_y, ETScreenW, ETScreenH);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -15, ETScreenW, 15)];
    headerView.backgroundColor = ETMinorBgColor;
    [self.promiseDetailsVC.view addSubview:headerView];
    
    UIView *tagView = [UIView new];
    tagView.backgroundColor = [UIColor colorWithRed:242/255.0 green:77/255.0 blue:77/255.0 alpha:1];
    [headerView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).with.offset(10);
        make.width.equalTo(@30);
        make.centerX.equalTo(headerView);
        make.height.equalTo(@3);
        tagView.layer.cornerRadius = 1.5;
    }];
    
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, kCalendar_HeaderHeight)];
    [headerButton addTarget:self action:@selector(changeControllerRect) forControlEvents:UIControlEventTouchUpInside];
    [self.promiseDetailsVC.view addSubview:headerButton];
    [self.view addSubview:self.promiseDetailsVC.view];
    
}

// 奖惩说明
- (void)createExplanationView {
    
    self.explanation = [UIButton buttonWithType:UIButtonTypeCustom];
    self.explanation.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.explanation.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.explanation addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.explanation setImage:[UIImage imageNamed:@"promise_explanation_backgroundImage"] forState:UIControlStateNormal];
    // 取消高亮
    self.explanation.adjustsImageWhenHighlighted = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.explanation];
    
    UILabel *explanationLabel = [[UILabel alloc] init];
    [self.explanation addSubview:explanationLabel];
    [explanationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.explanation);
        make.centerY.equalTo(self.explanation).with.offset(15);
        make.width.equalTo(@(self.explanation.frame.size.width / 2));
        make.height.equalTo(@(self.explanation.frame.size.height / 2));
    }];
    explanationLabel.textColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    explanationLabel.textAlignment = NSTextAlignmentCenter;
    explanationLabel.font = [UIFont systemFontOfSize:10];
    explanationLabel.numberOfLines = 0;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"公众承诺区目标最低天数：\n5天，低于5天的目标无法设立\n\n完成当日目标，积分奖励政策如下：\n5-10天 10分/天\n11-20天 30分/天\n21天以上 50分/天\n\n若有一天未达成承诺，\n所有积分均无法获得\n\n任何情况下取消承诺\n将无法获得奖励积分，\n并且追加扣除100分作为失信惩罚"];
    NSRange rang = NSMakeRange(13, 14);
    UIColor *redcolor = [UIColor colorWithRed:231/255.0 green:18/255.0 blue:17/255.0 alpha:1];
    [text addAttribute:NSForegroundColorAttributeName value:redcolor range:rang];
    rang = NSMakeRange(45, 37);
    [text addAttribute:NSForegroundColorAttributeName value:redcolor range:rang];
    rang = NSMakeRange(116, 9);
    [text addAttribute:NSForegroundColorAttributeName value:redcolor range:rang];
    explanationLabel.attributedText = text;
    
}

- (void)cancel {
    [self.explanation removeFromSuperview];
}

#pragma mark - 手势动画

- (void)createGestureRecognizer {
    
    UISwipeGestureRecognizer *swipe_up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipe_up.numberOfTouchesRequired = 1;
    swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swipe_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipe_down.numberOfTouchesRequired = 1;
    swipe_down.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipe_up];
    [self.view addGestureRecognizer:swipe_down];
    
}

- (void)swipeView:(UISwipeGestureRecognizer *)sender {
    [self changeControllerRect];
}

- (void)changeControllerRect {
    
    CGFloat bottom = CGRectGetMaxY(self.tableView.frame);
    CGFloat top = self.view.bounds.origin.y;
    CGFloat pdVC_y = self.promiseDetailsVC.view.frame.origin.y;
    if (pdVC_y == bottom) {
        [UIView animateWithDuration:0.5 // 动画持续时间
                              delay:0 // 动画延迟执行的时间
             usingSpringWithDamping:0.8 // 震动效果，范围0~1，数值越小震动效果越明显
              initialSpringVelocity:1 // 初始速度，数值越大初始速度越快
                            options:UIViewAnimationOptionLayoutSubviews // 动画的过渡效果
                         animations:^{
                             //执行的动画
                             CGRect rect = self.view.bounds;
                             rect.origin.y = top;
                             self.promiseDetailsVC.view.frame = rect;
//                             self.promiseDetailsVC.indicatorImg.transform = CGAffineTransformMakeScale(1.0, -1.0);
                             self.promiseDetailsVC.indicatorImg.hidden = YES;
                             [self.promiseDetailsVC getData];
                         }
                         completion:nil];
    } else if (pdVC_y == top) {
        [UIView animateWithDuration:0.5 // 动画持续时间
                              delay:0 // 动画延迟执行的时间
             usingSpringWithDamping:0.8 // 震动效果，范围0~1，数值越小震动效果越明显
              initialSpringVelocity:1 // 初始速度，数值越大初始速度越快
                            options:UIViewAnimationOptionLayoutSubviews // 动画的过渡效果
                         animations:^{
                             //执行的动画
                             self.promiseDetailsVC.view.frame = CGRectMake(0, bottom, ETScreenW, ETScreenH);
//                             self.promiseDetailsVC.indicatorImg.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             self.promiseDetailsVC.indicatorImg.hidden = NO;
                         }
                         completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公众承诺";
    [self getNavMenuData];
    [self createTableView];
    [self createCalendar];
    [self createGestureRecognizer];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNavMenuData {
    RightNavMenuModel *model1 = [[RightNavMenuModel alloc] init];
    model1.imageName = @"promise_explanation";
    model1.title = @"奖惩说明";
    
    RightNavMenuModel *model2 = [[RightNavMenuModel alloc] init];
    model2.imageName = @"promise_history";
    model2.title = @"历史目标";
    
    RightNavMenuModel *model3 = [[RightNavMenuModel alloc] init];
    model3.imageName = @"promise_history";
    model3.title = @"PK记录";
    
    [self.menuDataArray addObject:model1];
    [self.menuDataArray addObject:model2];
    [self.menuDataArray addObject:model3];
}

#pragma mark - RightNavMenuViewDelegate

- (void)didSelected:(NSIndexPath *)indexPath {
    [self removeNavMenuView];
    if (indexPath.row == 0) {
        [self createExplanationView];
    } else if (indexPath.row == 1) {
        HistoryPromiseVC *hpVC = [[HistoryPromiseVC alloc] init];
        [self.navigationController pushViewController:hpVC animated:YES];
    } else if (indexPath.row == 2) {
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = 0;
        homePageVC.viewModel.listType = ETListTypePKRecord;
        [self.navigationController pushViewController:homePageVC animated:YES];
//        PKGatherViewController *pkVC = [[PKGatherViewController alloc] init];
//        pkVC.isHistory = YES;
//        [self.navigationController pushViewController:pkVC animated:YES];
    }
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.dataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        static NSString *addPromiseViewCell = @"AddPromiseViewCell";
        AddPromiseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addPromiseViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:addPromiseViewCell owner:self options:nil].firstObject;
        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell setup];
        
        return cell;
        
    } else {
        
        static NSString *promiseOngoingViewCell = @"PromiseOngoingViewCell";
        PromiseOngoingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:promiseOngoingViewCell];
        
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:promiseOngoingViewCell owner:self options:nil].firstObject;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PromiseModel *model = self.dataArray[indexPath.row];
        [cell getDataWithModel:model];
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [MobClick event:@"SetPromise"];
//        ProjectVC *pVC = [[ProjectVC alloc] init];
//        [self.navigationController pushViewController:pVC animated:YES];
        ETSearchProjectVC *projectVC = [[ETSearchProjectVC alloc] init];
        projectVC.viewModel.isPromise = YES;
        [self.navigationController pushViewController:projectVC animated:YES];

    } else if (indexPath.section == 1) {
        PromiseModel *model = self.dataArray[indexPath.row];
        SinglePromiseDetailsVC *spdVC = [[SinglePromiseDetailsVC alloc] init];
        spdVC.targetID = [model.TargetID integerValue];
        spdVC.model = model;
        [self.navigationController pushViewController:spdVC animated:YES];
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
