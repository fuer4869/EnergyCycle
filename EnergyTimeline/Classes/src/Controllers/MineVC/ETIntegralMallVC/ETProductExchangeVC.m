//
//  ETProductExchangeVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProductExchangeVC.h"
#import "ETProductExchangeView.h"

#import "ETPopView.h"

@interface ETProductExchangeVC ()

@property (nonatomic, strong) ETProductExchangeView *mainView;

@property (nonatomic, strong) ETProductExchangeViewModel *viewModel;

@end

@implementation ETProductExchangeVC

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
    self.viewModel = (ETProductExchangeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.exchangeEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [ETPopView popViewWithTitle:@"兑换成功!" Tip:@"请等待工作人员与您联系"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)et_layoutNavigation {
    self.title = @"收货地址";
    self.view.backgroundColor = ETMainBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_didDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETProductExchangeView *)mainView {
    if (!_mainView) {
        _mainView = [[ETProductExchangeView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETProductExchangeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProductExchangeViewModel alloc] init];
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
