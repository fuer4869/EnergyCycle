//
//  ETIntegralMallVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralMallVC.h"
#import "ETIntegralMallView.h"

#import "ETIntegralRecordVC.h"

#import "ETProductDetailsVC.h"
#import "ETProductDetailsViewModel.h"

@interface ETIntegralMallVC ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) ETIntegralMallView *mainView;

@property (nonatomic, strong) ETIntegralMallViewModel *viewModel;

@end

@implementation ETIntegralMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETIntegralMallViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
//    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETProductDetailsViewModel *viewModel) {
        @strongify(self)
        viewModel.userModel = self.viewModel.model;
        ETProductDetailsVC *productVC = [[ETProductDetailsVC alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:productVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETIntegralMallVC"];
    self.title = @"积分商城";
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_White];
//    [self setupRightNavBarWithTitle:@"积分记录"];
    [self setupRightNavBarWithimage:@"mine_integralRecord_white"];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETIntegralMallVC"];
}

- (void)et_didDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    [MobClick event:@"ETIntegralRecordVC"];
    ETIntegralRecordVC *integralRecordVC = [[ETIntegralRecordVC alloc] init];
    [self.navigationController pushViewController:integralRecordVC animated:YES];
}

#pragma mark -- lazyLoad --

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:CGRectMake(0, 0, ETScreenW, 140) andColors:@[[UIColor colorWithHexString:@"f65e5f"], [UIColor colorWithHexString:@"fccacb"]]];
    }
    return _topView;
}

- (ETIntegralMallView *)mainView {
    if (!_mainView) {
        _mainView = [[ETIntegralMallView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETIntegralMallViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETIntegralMallViewModel alloc] init];
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
