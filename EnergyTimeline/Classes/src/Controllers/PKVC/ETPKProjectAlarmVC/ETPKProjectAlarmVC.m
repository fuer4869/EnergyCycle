//
//  ETPKProjectAlarmVC.m
//  能量圈
//
//  Created by 王斌 on 2018/1/24.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectAlarmVC.h"
#import "ETPKProjectAlarmView.h"

@interface ETPKProjectAlarmVC ()

@property (nonatomic, strong) ETPKProjectAlarmView *mainView;

@end

@implementation ETPKProjectAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"闹钟提醒";
    self.view.backgroundColor = ETMainBgColor;
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
    
    [[self.viewModel.completedSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self leftAction];
    }];
}

- (void)et_layoutNavigation {
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithTitle:@"保存"];
}

- (void)leftAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightAction {
    [self.viewModel.alarmUpdateCommand execute:nil];
}

#pragma mark -- lazyLoad --

- (ETPKProjectAlarmView *)mainView {
    if (!_mainView) {
        _mainView = [[ETPKProjectAlarmView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETPKProjectAlarmViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectAlarmViewModel alloc] init];
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
