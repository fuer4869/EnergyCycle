//
//  ETProjectTypeVC.m
//  能量圈
//
//  Created by 王斌 on 2018/1/8.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETProjectTypeVC.h"
#import "ETProjectTypeView.h"
//#import "ETProjectTypeViewModel.h"
#import "ETSearchProjectViewModel.h"

@interface ETProjectTypeVC ()

@property (nonatomic, strong) ETProjectTypeView *mainView;

@property (nonatomic, strong) ETSearchProjectViewModel *viewModel;

@end

@implementation ETProjectTypeVC

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
    self.viewModel = (ETSearchProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
//    [self.viewModel.]
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
}

#pragma mark -- lazyLoad --

- (ETProjectTypeView *)mainView {
    if (!_mainView) {
        _mainView = [[ETProjectTypeView alloc] initWithViewModel:self.viewModel];
        _mainView.typeIndex = self.typeIndex;
    }
    return _mainView;
}

- (ETSearchProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSearchProjectViewModel alloc] init];
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
