//
//  ETSignRankListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSignRankListVC.h"
#import "ETSignRankListView.h"
#import "ETSignRankListViewModel.h"

#import "ETRankModel.h"

#import "ETHomePageVC.h"

@interface ETSignRankListVC ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) ETSignRankListView *mainView;

@property (nonatomic, strong) ETSignRankListViewModel *viewModel;

@end

@implementation ETSignRankListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(weakSelf.view);
//        make.height.equalTo(@108);
//    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@kNavHeight);
//        make.left.right.bottom.equalTo(weakSelf.view);
        make.edges.equalTo(weakSelf.view);
    }];
    [super updateViewConstraints];
}

- (void)et_addSubviews {
//    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETRankModel *model) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [model.UserID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETSignRankListVC"];
    self.title = @"签到排名";
    [self setupLeftNavBarWithimage:ETLeftArrow_White];
    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETSignRankListVC"];
    [self resetNavigation];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, ETScreenW, 140) andColors:@[[UIColor colorWithHexString:@"f65e5f"], [UIColor colorWithHexString:@"fccacb"]]];
    }
    return _topView;
}

- (ETSignRankListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETSignRankListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETSignRankListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSignRankListViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
