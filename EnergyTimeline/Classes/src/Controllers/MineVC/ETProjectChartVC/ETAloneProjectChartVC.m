//
//  ETAloneProjectChartVC.m
//  能量圈
//
//  Created by 王斌 on 2017/8/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETAloneProjectChartVC.h"
#import "ETAloneProjectChartView.h"

@interface ETAloneProjectChartVC ()

@property (nonatomic, strong) ETAloneProjectChartView *mainView;

@end

@implementation ETAloneProjectChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@kNavHeight);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETAloneProjectChartVC"];
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ETMinorBgColor;
    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETAloneProjectChartVC"];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETAloneProjectChartView *)mainView {
    if (!_mainView) {
        _mainView = [[ETAloneProjectChartView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETAloneProjectChartViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETAloneProjectChartViewModel alloc] init];
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
