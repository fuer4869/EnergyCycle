//
//  ETMyInfoVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMyInfoVC.h"
#import "ETMyInfoView.h"
#import "ETMyInfoViewModel.h"

#import "ETPopView.h"
#import "ETMyInfoDetailVC.h"

@interface ETMyInfoVC ()

@property (nonatomic, strong) ETMyInfoView *mainView;

@property (nonatomic, strong) ETMyInfoViewModel *viewModel;

@end

@implementation ETMyInfoVC

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
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETMyInfoTableViewCellViewModel *infoViewModel) {
        @strongify(self);
        ETMyInfoDetailVC *detailVC = [[ETMyInfoDetailVC alloc] init];
        detailVC.viewModel = infoViewModel;
        [detailVC.backSubject subscribeNext:^(ETMyInfoTableViewCellViewModel *infoViewModel) {
            @strongify(self)
            self.viewModel.infoModel = infoViewModel;
            [self.viewModel.refreshUserModelSubject sendNext:nil];
        }];
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
    [[self.viewModel.editSuccessSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        [ETPopView popViewWithTip:@"修改成功"];
    }];
}

- (void)et_layoutNavigation {
    self.title = @"我的资料";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithTitle:@"保存"];
    self.navigationController.navigationBar.tintColor = ETBlackColor;
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.viewModel.cancelSubject sendNext:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    [self.viewModel.editInfoCommand execute:nil];
}

#pragma mark -- lazyLoad --

- (ETMyInfoView *)mainView {
    if (!_mainView) {
        _mainView = [[ETMyInfoView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETMyInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMyInfoViewModel alloc] init];
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
