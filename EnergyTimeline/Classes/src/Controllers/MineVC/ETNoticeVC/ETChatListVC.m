//
//  ETChatListVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETChatListVC.h"
#import "ETChatListView.h"
#import "ETChatListViewModel.h"

#import "ETMessageVC.h"

@interface ETChatListVC ()

@property (nonatomic, strong) ETChatListView *mainView;

@property (nonatomic, strong) ETChatListViewModel *viewModel;

@end

@implementation ETChatListVC

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
    [self.viewModel.refreshDataCommand execute:nil];

    [self.viewModel.cellClickSubject subscribeNext:^(ChatListModel *model) {
        @strongify(self)
        ETMessageVC *messageVC = [[ETMessageVC alloc] init];
        messageVC.viewModel.toUserNickName = model.NickName;
        messageVC.viewModel.toUserID = model.UserID;
        [self.navigationController pushViewController:messageVC animated:YES];
    }];
}

- (void)et_layoutNavigation {
    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETChatListView *)mainView {
    if (!_mainView) {
        _mainView = [[ETChatListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETChatListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETChatListViewModel alloc] init];
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
