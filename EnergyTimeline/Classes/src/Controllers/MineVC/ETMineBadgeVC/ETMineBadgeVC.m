//
//  ETMineBadgeVC.m
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineBadgeVC.h"
#import "ETMineBadgeView.h"
#import "ETMineBadgeViewModel.h"

@interface ETMineBadgeVC ()

@property (nonatomic, strong) ETMineBadgeView *mainView;

@property (nonatomic, strong) ETMineBadgeViewModel *viewModel;

@end

@implementation ETMineBadgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETMineBadgeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
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

//- (void)et_bindViewModel {
//    @weakify(self)
//    [self.viewModel.refreshDataCommand execute:nil];
//}

- (void)et_layoutNavigation {
    self.navigationController.navigationBar.translucent = YES;
}
//
//- (void)leftAction {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)et_willDisappear {
//    [MobClick endLogPageView:@"ETMineBadgeVC"];
//    [self resetNavigation];
//}

#pragma mark -- lazyLoad --

- (ETMineBadgeView *)mainView {
    if (!_mainView) {
        _mainView = [[ETMineBadgeView alloc] initWithViewModel:self.viewModel];
        _mainView.badgeType = self.badgeType;
    }
    return _mainView;
}

- (ETMineBadgeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMineBadgeViewModel alloc] init];
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
