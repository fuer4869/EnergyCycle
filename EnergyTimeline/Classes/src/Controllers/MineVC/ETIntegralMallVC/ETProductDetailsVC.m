//
//  ETProductDetailsVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProductDetailsVC.h"
#import "ETProductDetailsView.h"
#import "ETProductDetailsViewModel.h"

#import "ETProductExchangeVC.h"

@interface ETProductDetailsVC ()

@property (nonatomic, strong) ETProductDetailsView *mainView;

@property (nonatomic, strong) ETProductDetailsViewModel *viewModel;

@end

@implementation ETProductDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETProductDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.exchangeSubject subscribeNext:^(id x) {
        @strongify(self)
        ETProductExchangeViewModel *viewModel = [[ETProductExchangeViewModel alloc] init];
        viewModel.productID = [self.viewModel.model.ProductID integerValue];
        ETProductExchangeVC *exchangeVC = [[ETProductExchangeVC alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }];
    
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_White];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)et_didAppear {
    /** 因为前一个页面会清除导航栏的设置所以必须要在这个地方重新设置导航栏属性 */
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_White];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)et_didDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETProductDetailsView *)mainView {
    if (!_mainView) {
        _mainView = [[ETProductDetailsView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETProductDetailsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProductDetailsViewModel alloc] init];
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
