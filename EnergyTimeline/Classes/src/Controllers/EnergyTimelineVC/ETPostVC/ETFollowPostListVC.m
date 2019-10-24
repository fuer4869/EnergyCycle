//
//  ETFollowPostListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETFollowPostListVC.h"
#import "ETFollowPostListView.h"

@interface ETFollowPostListVC ()

@property (nonatomic, strong) ETFollowPostListView *mainView;

@end

@implementation ETFollowPostListVC

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
    
}

#pragma mark -- lazyLoad --

- (ETFollowPostListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETFollowPostListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETFollowPostListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETFollowPostListViewModel alloc] init];
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
