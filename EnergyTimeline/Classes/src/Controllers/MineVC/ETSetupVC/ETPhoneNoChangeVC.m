//
//  ETPhoneNoChangeVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPhoneNoChangeVC.h"
#import "ETPhoneNoChangeView.h"
#import "ETPhoneNoChangeViewModel.h"

#import "ETLoginVC.h"

@interface ETPhoneNoChangeVC ()

@property (nonatomic, strong) ETPhoneNoChangeView *mainView;

@property (nonatomic, strong) ETPhoneNoChangeViewModel *viewModel;

@end

@implementation ETPhoneNoChangeVC

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
    [[self.viewModel.changeEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETLoginVC *loginVC = [[ETLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
}

- (void)et_layoutNavigation {
    self.title = @"更换手机号";
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

- (ETPhoneNoChangeView *)mainView {
    if (!_mainView) {
        _mainView = [[ETPhoneNoChangeView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETPhoneNoChangeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPhoneNoChangeViewModel alloc] init];
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
