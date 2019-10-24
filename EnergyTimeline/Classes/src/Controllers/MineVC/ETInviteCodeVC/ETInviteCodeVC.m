//
//  ETInviteCodeVC.m
//  能量圈
//
//  Created by 王斌 on 2018/2/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETInviteCodeVC.h"
#import "ETInviteCodeView.h"
#import "ETInviteCodeViewModel.h"

@interface ETInviteCodeVC ()

@property (nonatomic, strong) ETInviteCodeView *mainView;

@property (nonatomic, strong) ETInviteCodeViewModel *viewModel;

@end

@implementation ETInviteCodeVC

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

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
//    @weakify(self)
    
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETInviteCodeVC"];
    self.title = @"能量圈";
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithTitle:@"提交"];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETInviteCodeVC"];
}

- (void)et_didDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    [self.viewModel.inviteCodeCommand execute:nil];
}

#pragma mark -- lazyLoad --

- (ETInviteCodeView *)mainView {
    if (!_mainView) {
        _mainView = [[ETInviteCodeView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETInviteCodeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETInviteCodeViewModel alloc] init];
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
