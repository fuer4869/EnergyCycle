//
//  ETRadioVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRadioVC.h"
#import "ETRadioView.h"
#import "ETRadioViewModel.h"

#import "ETNavigationController.h"
#import "RadioDurationTimeVC.h"
#import "RadioPlaySettingVC.h"

@interface ETRadioVC ()

@property (nonatomic, strong) ETRadioView *mainView;

@property (nonatomic, strong) ETRadioViewModel *viewModel;

@end

@implementation ETRadioVC

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

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETRadioViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.dismissSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.viewModel.radioPlayVCSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        RadioPlaySettingVC *playVC = [[RadioPlaySettingVC alloc] init];
        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:playVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
    
    [[self.viewModel.radioDurationTimeVCSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        RadioDurationTimeVC *durationVC = [[RadioDurationTimeVC alloc] init];
        ETNavigationController *navVC = [[ETNavigationController alloc] initWithRootViewController:durationVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETRadioVC"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = ETMinorBgColor;
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETRadioVC"];
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ETRadioView *)mainView {
    if (!_mainView) {
        _mainView = [[ETRadioView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
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
