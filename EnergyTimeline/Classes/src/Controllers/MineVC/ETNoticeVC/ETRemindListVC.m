//
//  ETRemindListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRemindListVC.h"
#import "ETRemindListView.h"
#import "ETRemindListViewModel.h"

#import "ETNewFansListVC.h"
#import "ETNoticeCommentListVC.h"
#import "ETNoticeLikeListVC.h"
#import "ETMentionListVC.h"
#import "ETNoticeVC.h"

@interface ETRemindListVC ()

@property (nonatomic, strong) ETRemindListView *mainView;

@property (nonatomic, strong) ETRemindListViewModel *viewModel;

@end

@implementation ETRemindListVC

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
    [self.viewModel.cellClickSubject subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self)
        switch (indexPath.row) {
            case 0: {
                ETNewFansListVC *newFansVC = [[ETNewFansListVC alloc] init];
                [self showViewController:newFansVC sender:nil];
            }
                break;
            case 1: {
                ETNoticeCommentListVC *commentVC = [[ETNoticeCommentListVC alloc] init];
                [self showViewController:commentVC sender:nil];
            }
                break;
            case 2: {
                ETNoticeLikeListVC *likeVC = [[ETNoticeLikeListVC alloc] init];
                [self showViewController:likeVC sender:nil];
                
            }
                break;
            case 3: {
                ETMentionListVC *mentionVC = [[ETMentionListVC alloc] init];
                [self showViewController:mentionVC sender:nil];
            }
                break;
            case 4: {
                ETNoticeVC *noticeVC = [[ETNoticeVC alloc] init];
                [self showViewController:noticeVC sender:nil];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)et_getNewData {
    [self.viewModel.refreshDataCommand execute:nil];
}

- (void)et_layoutNavigation {
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETRemindListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETRemindListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETRemindListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETRemindListViewModel alloc] init];
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
