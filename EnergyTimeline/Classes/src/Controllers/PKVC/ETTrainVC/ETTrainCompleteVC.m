//
//  ETTrainCompleteVC.m
//  能量圈
//
//  Created by 王斌 on 2018/4/18.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainCompleteVC.h"
#import "ETTrainCompleteView.h"
#import "ETReportPostVC.h"
#import "ETReportPostNavController.h"

#import "ETTrainViewModel.h"

#import "ETTrainAudioManager.h"

@interface ETTrainCompleteVC ()

@property (nonatomic, strong) ETTrainCompleteView *mainView;

@property (nonatomic, strong) ETTrainViewModel *viewModel;

@end

@implementation ETTrainCompleteVC

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
    self.viewModel = (ETTrainViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.trainFinishEndSubject subscribeNext:^(id x) {
        @strongify(self)
        
        [[ETTrainAudioManager sharedInstance] trainEnd];

        ETReportPostVC *postVC = [[ETReportPostVC alloc] init];
        ETReportPostNavController *postNavVC = [[ETReportPostNavController alloc] initWithRootViewController:postVC];
        [self presentViewController:postNavVC animated:YES completion:nil];
    }];
    
    [self.viewModel.closeSubject subscribeNext:^(id x) {
        @strongify(self)
        
        [[ETTrainAudioManager sharedInstance] trainEnd];
        
        UIViewController *presnetingVC = self;
        while (presnetingVC.presentingViewController) {
            presnetingVC = presnetingVC.presentingViewController;
        }
        [presnetingVC dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark -- lazyLoad --

- (ETTrainCompleteView *)mainView {
    if (!_mainView) {
        _mainView = [[ETTrainCompleteView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETTrainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainViewModel alloc] init];
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
