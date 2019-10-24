//
//  ETOpinionVC.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETOpinionVC.h"
#import "ETOpinionView.h"
#import "ETOpinionViewModel.h"

#import "ETReportOpinionPostVC.h"

#import "ETWebVC.h"
#import "ETHomePageVC.h"

@interface ETOpinionVC ()

@property (nonatomic, strong) ETOpinionView *mainView;

@property (nonatomic, strong) ETOpinionViewModel *viewModel;

@end

@implementation ETOpinionVC

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
    self.viewModel = (ETOpinionViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        @strongify(self)
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypePost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    
}

- (void)et_layoutNavigation {
    self.title = @"我要吐槽";
    self.view.backgroundColor = ETMainBgColor;
    [self setupLeftNavBarWithimage:ETLeftArrow_White];
    [self setupRightNavBarWithTitle:@"发帖"];
//    [self setupRightNavBarWithimage:@"mine_opinion_gray"];
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    ETReportOpinionPostVC *postVC = [[ETReportOpinionPostVC alloc] init];
    [self.navigationController pushViewController:postVC animated:YES];
}

- (ETOpinionView *)mainView {
    if (!_mainView) {
        _mainView = [[ETOpinionView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETOpinionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETOpinionViewModel alloc] init];
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
