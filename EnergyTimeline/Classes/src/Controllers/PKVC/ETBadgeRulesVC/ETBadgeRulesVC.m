//
//  ETBadgeRulesVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETBadgeRulesVC.h"
#import "ETBadgeRulesView.h"
#import "ETBadgeRulesViewModel.h"

@interface ETBadgeRulesVC ()

@property (nonatomic, strong) ETBadgeRulesView *mainView;

@property (nonatomic, strong) ETBadgeRulesViewModel *viewModel;

@end

@implementation ETBadgeRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
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
    
}

- (void)et_layoutNavigation {
    self.title = @"徽章规则";
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETBadgeRulesView *)mainView {
    if (!_mainView) {
        _mainView = [[ETBadgeRulesView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETBadgeRulesViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETBadgeRulesViewModel alloc] init];
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
