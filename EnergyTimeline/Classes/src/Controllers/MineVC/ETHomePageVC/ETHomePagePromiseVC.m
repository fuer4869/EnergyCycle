//
//  ETHomePagePromiseVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePagePromiseVC.h"
#import "ETHomePagePromiseView.h"
#import "ETHomePageViewModel.h"

@interface ETHomePagePromiseVC ()

@property (nonatomic, strong) ETHomePagePromiseView *mainView;

@property (nonatomic, strong) ETHomePageViewModel *viewModel;

@end

@implementation ETHomePagePromiseVC

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

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETHomePageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETClearColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

#pragma mark -- lazyLoad --

- (ETHomePagePromiseView *)mainView {
    if (!_mainView) {
        _mainView = [[ETHomePagePromiseView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETHomePageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETHomePageViewModel alloc] init];
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
