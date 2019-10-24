//
//  ETNoticeCommentListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNoticeCommentListVC.h"
#import "ETNoticeCommentListView.h"
#import "ETNoticeCommentListViewModel.h"

#import "NoticeCommentModel.h"

#import "ETHomePageVC.h"
#import "ETWebVC.h"

@interface ETNoticeCommentListVC ()

@property (nonatomic, strong) ETNoticeCommentListView *mainView;

@property (nonatomic, strong) ETNoticeCommentListViewModel *viewModel;

@end

@implementation ETNoticeCommentListVC

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
    [[self.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [self.viewModel.cellClickSubject subscribeNext:^(NoticeCommentModel *model) {
        @strongify(self)
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypePost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
    self.navigationController.navigationBar.translucent = NO;

    self.title = @"评论";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETNoticeCommentListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETNoticeCommentListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETNoticeCommentListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETNoticeCommentListViewModel alloc] init];
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
