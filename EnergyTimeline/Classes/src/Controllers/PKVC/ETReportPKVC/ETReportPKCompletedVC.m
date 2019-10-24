//
//  ETReportPKCompletedVC.m
//  能量圈
//
//  Created by 王斌 on 2017/10/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKCompletedVC.h"
#import "ETReportPKCompletedView.h"
#import "ETReportPKCompletedViewModel.h"

#import "ETReportPostVC.h"
#import "ETReportPostNavController.h"

#import "ETRemindView.h"

@interface ETReportPKCompletedVC ()

@property (nonatomic, strong) ETReportPKCompletedView *mainView;

@property (nonatomic, strong) ETReportPKCompletedViewModel *viewModel;

@end

@implementation ETReportPKCompletedVC

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportPKCompleted" object:nil];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [[self.viewModel.completedSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
//        NSString *pkReportUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"PKReportUIUpdate"];
//        if (!pkReportUpdate) {
//            if (@available(iOS 11.0, *)) {
//                [ETRemindView remindImageName:@"remind_pk_report_X"];
//            } else {
//                [ETRemindView remindImageName:@"remind_pk_report"];
//            }
//            pkReportUpdate = @"2.3";
//            [[NSUserDefaults standardUserDefaults] setObject:pkReportUpdate forKey:@"PKReportUIUpdate"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportPKCompleted" object:nil];

        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [[self.viewModel.reportPostSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        ETReportPostVC *postVC = [[ETReportPostVC alloc] init];
        ETReportPostNavController *postNavVC = [[ETReportPostNavController alloc] initWithRootViewController:postVC];
        [self presentViewController:postNavVC animated:YES completion:nil];
    }];
    
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- lazyLoad --

- (ETReportPKCompletedView *)mainView {
    if (!_mainView) {
        _mainView = [[ETReportPKCompletedView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETReportPKCompletedViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETReportPKCompletedViewModel alloc] init];
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
