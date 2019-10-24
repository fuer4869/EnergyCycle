//
//  ETPKProjectRecordVC.m
//  能量圈
//
//  Created by 王斌 on 2017/12/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKProjectRecordVC.h"
#import "ETPKProjectRecordView.h"
#import "ETPKProjectViewModel.h"

@interface ETPKProjectRecordVC ()

@property (nonatomic, strong) ETPKProjectRecordView *mainView;

@property (nonatomic, strong) ETPKProjectViewModel *viewModel;

@end

@implementation ETPKProjectRecordVC

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
    
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
}

- (void)et_willDisappear {
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ETPKProjectRecordView *)mainView {
    if (!_mainView) {
        _mainView = [[ETPKProjectRecordView alloc] initWithViewModel:self.viewModel];
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
