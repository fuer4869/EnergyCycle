//
//  ETNewFansListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNewFansListVC.h"
#import "ETNewFansListView.h"
#import "ETNewFansListViewModel.h"

#import "ETHomePageVC.h"

@interface ETNewFansListVC ()

@property (nonatomic, strong) ETNewFansListView *mainView;

@property (nonatomic, strong) ETNewFansListViewModel *viewModel;

@end

@implementation ETNewFansListVC

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
    [self.viewModel.cellClickSubject subscribeNext:^(UserModel *model) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [model.UserID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
//    [self resetNavigation];
    /** homePage返回时做的操作 */
//    self.navigationController.navigationBar.translucent = NO;

    self.title = @"新粉丝";
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

- (ETNewFansListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETNewFansListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETNewFansListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETNewFansListViewModel alloc] init];
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
