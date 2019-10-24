//
//  ETAboutVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETAboutVC.h"
#import "ETAboutView.h"
#import "ETAboutViewModel.h"

#import "ETIntroductionVC.h"

@interface ETAboutVC ()

@property (nonatomic, strong) ETAboutView *mainView;

@property (nonatomic, strong) ETAboutViewModel *viewModel;

@end

@implementation ETAboutVC

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
    @weakify(self)
    [self.viewModel.cellClickSubject subscribeNext:^(id x) {
//        NSLog(@"功能介绍");
        @strongify(self)
        ETIntroductionVC *introductionVC = [[ETIntroductionVC alloc] init];
        [self.navigationController pushViewController:introductionVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
    self.title = @"关于能量圈";
    self.view.backgroundColor = ETMainBgColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETAboutView *)mainView {
    if (!_mainView) {
        _mainView = [[ETAboutView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETAboutViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETAboutViewModel alloc] init];
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
