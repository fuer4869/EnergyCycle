//
//  ETTabbarController.m
//  能量圈
//
//  Created by 王斌 on 2017/5/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETTabbarController.h"

/** ViewModel 处理数据与事件 */
#import "ETTabbarViewModel.h"

/** 中心菜单 */
#import "ETPopupMenuView.h"

/** 子控制器器 */
#import "ETPKVC.h"
#import "ETEnergyTimelineVC.h"
#import "ETFindVC.h"
#import "ETMineVC.h"
#import "ETReportPKVC.h"
#import "ETReportPostVC.h"
#import "PromiseVC.h"

/** 登录 */
#import "ETLoginVC.h"

/** 红点 */
#import "UITabBar+Badge.h"

/** 子控制器的根控制器 */
#import "ETEnergyTimelineNavController.h"
#import "ETPKNavController.h"
#import "ETFindNavController.h"
#import "ETMineNavController.h"
#import "ETReportPKNavController.h"
#import "ETReportPostNavController.h"

@interface ETTabbarController () <UITabBarControllerDelegate, ETPopupMenuViewDelegate>

@property (nonatomic, strong) UIButton *menu;

@property (nonatomic, strong) UITabBarItem *currentItem;

@property (nonatomic, strong) ETTabbarViewModel *viewModel;

@end

@implementation ETTabbarController

- (UIButton *)menu {
    if (!_menu) {
        _menu = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menu addTarget:self action:@selector(popupMenu) forControlEvents:UIControlEventTouchUpInside];
        [_menu setBackgroundImage:[UIImage imageNamed:@"ETPopupMenu_center"] forState:UIControlStateNormal];
        _menu.adjustsImageWhenHighlighted = NO;
    }
    return _menu;
}

- (void)popupMenu {
    [ETPopupMenuView showWithDelegate:self MenuBtn:self.menu MenuItems:@[@"ETPopupMenu_pk", @"ETPopupMenu_post", @"ETPopupMenu_promise"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.currentItem = self.tabBar.selectedItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self setup];
    [self setChlidVC];
    [self setCenterMenu];
    
    [[self.viewModel.refreshEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        NSString *setupUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MineSetupUIUpdate"];
        if (!setupUpdate || self.viewModel.noticeNotReadCount) {
            [self.tabBarController.tabBar showBadgeItemOnIndex:4];
        }
    }];
    
    // Do any additional setup after loading the view.
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    
//    NSLog(@"%d", item.tag);
//    if (!item.tag && !User_Status) {
//        NSLog(@"未登录");
//    }
//}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedViewController == viewController) {
        [self.viewModel.backListTopSubject sendNext:nil];
    } else {
        NSDictionary *dic = @{@"ControllerName" : viewController.tabBarItem.title};
        [MobClick event:@"ETTabBarVCClick" attributes:dic];
    }
//    if (viewController != self.viewControllers[0] && !User_Status) {
    if (!User_Status) {
        ETLoginVC *loginVC = [[ETLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark -- setup --

- (void)setCenterMenu {
//    CGFloat window_w = self.view.frame.size.width;
    CGFloat window_h = self.view.frame.size.height;
    CGFloat tabbar_h = self.tabBar.frame.size.height;
    CGFloat tab_h = kTabBarHeight;
    CGFloat grid_w = self.view.frame.size.width / 5;
//    CGFloat
    /** 遮罩层 */
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(grid_w * 2, window_h - tab_h, grid_w, tabbar_h)];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(grid_w * 2, self.tabBar.frame.origin.y, grid_w, self.tabBar.jk_height)];
    view.backgroundColor = ETMainBgColor;
    [self.view addSubview:view];
    /** 菜单按钮 */
    self.menu.frame = CGRectMake(0, 0, 40, 40);
//    self.menu.center = CGPointMake(window_w / 2, window_h - (tab_h - tabbar_h) - (tabbar_h / 2));
    self.menu.center = view.center;
    [self.view addSubview:self.menu];
}

- (void)setup {
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setBackgroundColor:ETMainBgColor];
    [self.tabBar setShadowImage:[UIImage new]];
//    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.tabBar.layer.shadowOpacity = 0.3;
//    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setChlidVC {
    
    ETPKVC *pkVC = [[ETPKVC alloc] init];
    [self setTabBarWithItem:pkVC.tabBarItem Title:@"首页" Tag:0 ImageName:@"pk"];
    ETPKNavController *pkNavVC = [[ETPKNavController alloc] initWithRootViewController:pkVC];
    
    ETEnergyTimelineVC *energyTimelineVC = [[ETEnergyTimelineVC alloc] init];
    energyTimelineVC.backListTopSubject = self.viewModel.backListTopSubject;
    [self setTabBarWithItem:energyTimelineVC.tabBarItem Title:@"动态" Tag:1 ImageName:@"post"];
    ETEnergyTimelineNavController *energyTimelineNavVC = [[ETEnergyTimelineNavController alloc] initWithRootViewController:energyTimelineVC];
    
//    ETPKVC *pkVC = [[ETPKVC alloc] init];
//    [self setTabBarWithItem:pkVC.tabBarItem Title:@"PK" Tag:1];
//    ETPKNavController *pkNavVC = [[ETPKNavController alloc] initWithRootViewController:pkVC];
    
    UIViewController *centerVC = [[UIViewController alloc] init];
    centerVC.tabBarItem.title = @"发布";
    [centerVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];
    
    ETFindVC *findVC = [[ETFindVC alloc] init];
    [self setTabBarWithItem:findVC.tabBarItem Title:@"发现" Tag:2 ImageName:@"find"];
    ETFindNavController *findNavVC = [[ETFindNavController alloc] initWithRootViewController:findVC];
    
    ETMineVC *mineVC = [[ETMineVC alloc] init];
    [self setTabBarWithItem:mineVC.tabBarItem Title:@"我的" Tag:3 ImageName:@"mine"];
    ETMineNavController *mineNavVC = [[ETMineNavController alloc] initWithRootViewController:mineVC];
    
    self.viewControllers = @[pkNavVC, energyTimelineNavVC, centerVC, findNavVC, mineNavVC];
    
}

//- (void)setTabBarWithItem:(UITabBarItem *)item Title:(NSString *)title Tag:(int)tag {
//    item.title = title;
//    item.tag = tag;
//    [item setTitlePositionAdjustment:UIOffsetMake(0, -2)];
//    UIColor *titlecolor = ETMinorColor;
//    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:titlecolor} forState:UIControlStateSelected];
//    item.image = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_normal_%d", (tag + 1)]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    item.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_pressed_%d", (tag + 1)]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//}

- (void)setTabBarWithItem:(UITabBarItem *)item Title:(NSString *)title Tag:(int)tag ImageName:(NSString *)imageName{
    item.title = title;
    item.tag = tag;
    [item setTitlePositionAdjustment:UIOffsetMake(0, -2)];
//    UIColor *titlecolor = ETMainBgColor;
    UIColor *titileColor = ETClearColor;
    item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:titileColor} forState:UIControlStateSelected];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:titileColor} forState:UIControlStateNormal];
    item.image = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_normal_%@", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"tabbar_pressed_%@", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait; // 支持正常方向
}

#pragma mark -- private --

- (void)setToSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex];
}

#pragma mark -- ETPopupMenuViewDelegate --

- (void)popupMenuView:(ETPopupMenuView *)view selectedIndex:(NSInteger)index {
    if (!User_Status) {
        ETLoginVC *loginVC = [[ETLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    switch (index) {
        case 0: {
            [MobClick event:@"ETReportPKVCEnterClick"];
            ETReportPKVC *pkVC = [[ETReportPKVC alloc] init];
            ETReportPKNavController *pkNavVC = [[ETReportPKNavController alloc] initWithRootViewController:pkVC];
            [self presentViewController:pkNavVC animated:YES completion:nil];
        }
            break;
        case 1: {
            [MobClick event:@"ETReportPostVCEnterClick"];
            ETReportPostVC *postVC = [[ETReportPostVC alloc] init];
            ETReportPostNavController *postNavVC = [[ETReportPostNavController alloc] initWithRootViewController:postVC];
            [self presentViewController:postNavVC animated:YES completion:nil];
        }
            break;
        case 2: {
            [MobClick event:@"ETPromiseVCEnterClick"];
            PromiseVC *promiseVC = [[PromiseVC alloc] init];
            ETNavigationController *promiseNavVC = [[ETNavigationController alloc] initWithRootViewController:promiseVC];
            [self presentViewController:promiseNavVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- lazyLoad --

- (ETTabbarViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTabbarViewModel alloc] init];
    }
    return _viewModel;
}

@end
