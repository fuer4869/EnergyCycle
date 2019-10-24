//
//  ETPKProjectRankVC.m
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRankVC.h"
#import "ETPKProjectRankView.h"
#import "ETPKProjectViewModel.h"

#import "ETPKProjectAlarmVC.h"
#import "ETWebVC.h"

@interface ETPKProjectRankVC ()

@property (nonatomic, strong) ETPKProjectRankView *mainView;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKProjectRankVC

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

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.integralRuleSubject subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETIntegralRuleClick_PKProjectRankVC"];
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypeAgreement;
        webVC.url = [NSString stringWithFormat:@"%@%@", INTERFACE_URL, HTML_IntegralRule];
        [self.navigationController showViewController:webVC sender:nil];
    }];
    
    [self.viewModel.projectAlarmSubject subscribeNext:^(id x) {
        @strongify(self)
        ETPKProjectAlarmVC *alarmVC = [[ETPKProjectAlarmVC alloc] init];
        alarmVC.viewModel.projectModel = self.viewModel.model;
        UINavigationController *alarmNavVC = [[UINavigationController alloc] initWithRootViewController:alarmVC];
        [ETWindow.rootViewController presentViewController:alarmNavVC animated:YES completion:nil];
    }];
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
}

- (void)et_willDisappear {
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ETPKProjectRankView *)mainView {
    if (!_mainView) {
        _mainView = [[ETPKProjectRankView alloc] initWithViewModel:self.viewModel];
        _mainView.scrollDelegate = self.scrollDelegate;
    }
    return _mainView;
}

- (ETPKProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectViewModel alloc] init];
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
