//
//  ETTrainTargetVC.m
//  能量圈
//
//  Created by 王斌 on 2018/3/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainTargetVC.h"
#import "ETTrainTargetView.h"

#import "ETTrainVC.h"

@interface ETTrainTargetVC ()

@property (nonatomic, strong) ETTrainTargetView *mainView;


@end

@implementation ETTrainTargetVC

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

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETTrainTargetVC"];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.backSubject subscribeNext:^(id x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.viewModel.nextSubject subscribeNext:^(id x) {
        @strongify(self)
        ETTrainVC *trainVC = [[ETTrainVC alloc] init];
        trainVC.viewModel.trainID = self.viewModel.trainID;
        [self presentViewController:trainVC animated:YES completion:nil];
    }];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETTrainTargetVC"];
}

#pragma mark -- lazyLoad --

- (ETTrainTargetView *)mainView {
    if (!_mainView) {
        _mainView = [[ETTrainTargetView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETTrainTargetViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainTargetViewModel alloc] init];
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
