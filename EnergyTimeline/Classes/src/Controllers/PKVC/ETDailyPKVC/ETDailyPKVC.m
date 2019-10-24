//
//  ETDailyPKVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/14.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKVC.h"
#import "ETDailyPKView.h"

#import "ETHomePageVC.h"
#import "ETWebVC.h"

@interface ETDailyPKVC ()

@property (nonatomic, strong) ETDailyPKView *mainView;

@end

@implementation ETDailyPKVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
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

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETDailyPKViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
    
//    [self.viewModel.cellClickSubject subscribeNext:^(id x) {
//        @strongify(self)
//    }];
    
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
    
}

#pragma mark -- lazyLoad --

- (ETDailyPKView *)mainView {
    if (!_mainView) {
        _mainView = [[ETDailyPKView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETDailyPKViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETDailyPKViewModel alloc] init];
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
