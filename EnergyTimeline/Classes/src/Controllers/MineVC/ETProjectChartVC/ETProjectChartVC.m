//
//  ETProjectChartVC.m
//  能量圈
//
//  Created by 王斌 on 2017/8/7.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectChartVC.h"
#import "ETProjectChartView.h"
#import "ETProjectChartViewModel.h"

@interface ETProjectChartVC ()

@property (nonatomic, strong) ETProjectChartView *mainView;

@property (nonatomic, strong) ETProjectChartViewModel *viewModel;

@end

@implementation ETProjectChartVC

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

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
//    @weakify(self)
//    [self.viewModel]
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETProjectChartVC"];
    self.title = @"数据曲线";
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETProjectChartVC"];
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETProjectChartView *)mainView {
    if (!_mainView) {
        _mainView = [[ETProjectChartView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETProjectChartViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProjectChartViewModel alloc] init];
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
