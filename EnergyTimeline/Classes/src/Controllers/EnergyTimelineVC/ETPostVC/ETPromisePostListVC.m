//
//  ETPromisePostListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPromisePostListVC.h"
#import "ETPromisePostListView.h"

@interface ETPromisePostListVC ()

@property (nonatomic, strong) ETPromisePostListView *mainView;

@end

@implementation ETPromisePostListVC

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
//    @weakify(self)
//    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
//        @strongify(self)
//        NSLog(@"%@",x);
//    }];
}

- (ETPromisePostListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETPromisePostListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETPromisePostListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPromisePostListViewModel alloc] init];
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
