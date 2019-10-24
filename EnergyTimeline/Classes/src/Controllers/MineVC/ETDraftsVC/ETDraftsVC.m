//
//  ETDraftsVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDraftsVC.h"
#import "ETDraftsView.h"
#import "ETDraftsViewModel.h"

#import "ETReportPostVC.h"
#import "ETReportPostNavController.h"

@interface ETDraftsVC ()

@property (nonatomic, strong) ETDraftsView *mainView;

@property (nonatomic, strong) ETDraftsViewModel *viewModel;

@end

@implementation ETDraftsVC

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
    [self.viewModel.resendSubejct subscribeNext:^(DraftsModel *model) {
        @strongify(self)
        ETReportPostVC *postVC = [[ETReportPostVC alloc] init];
        postVC.viewModel.draftModel = model;
        ETReportPostNavController *postNavVC = [[ETReportPostNavController alloc] initWithRootViewController:postVC];
        [self presentViewController:postNavVC animated:YES completion:nil];
    }];
}

- (void)et_layoutNavigation {
    self.title = @"草稿箱";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETDraftsView *)mainView {
    if (!_mainView) {
        _mainView = [[ETDraftsView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETDraftsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETDraftsViewModel alloc] init];
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
