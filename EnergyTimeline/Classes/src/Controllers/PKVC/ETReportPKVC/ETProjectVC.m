//
//  ETProjectVC.m
//  能量圈
//
//  Created by 王斌 on 2017/8/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectVC.h"
#import "ETProjectView.h"

@interface ETProjectVC ()

@property (nonatomic, strong) ETProjectView *mainView;

@end

@implementation ETProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目";
    self.view.backgroundColor = ETProjectRelatedBGColor;
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
//    @weakify(self)
    
}

- (void)et_layoutNavigation {
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithTitle:@"完成"];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    if (self.viewModel.selectArray.count) {
        [self.viewModel.selectProjectSubject sendNext:self.viewModel.selectArray];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [MBProgressHUD showMessage:@"至少选择一个项目"];
    }
}

- (void)et_willDisappear {
    [self resetNavigation];
}

#pragma mark -- lazyLoad --

- (ETProjectView *)mainView {
    if (!_mainView) {
        _mainView = [[ETProjectView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProjectViewModel alloc] init];
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
