//
//  ETLogPostListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLogPostListVC.h"
#import "ETLogPostListView.h"

@interface ETLogPostListVC ()

@property (nonatomic, strong) ETLogPostListView *mainView;

@end

@implementation ETLogPostListVC

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

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
//    @weakify(self)
//    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
//        @strongify(self)
//        NSLog(@"%@", x);
//    }];
}

#pragma mark -- lazyLoad --

- (ETLogPostListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETLogPostListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETLogPostListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETLogPostListViewModel alloc] init];
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
