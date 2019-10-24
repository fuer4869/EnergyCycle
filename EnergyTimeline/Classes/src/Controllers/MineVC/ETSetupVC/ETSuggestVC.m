//
//  ETSuggestVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSuggestVC.h"
#import "ETSuggestViewModel.h"

@interface ETSuggestVC ()

@property (nonatomic, strong) UITextView *suggestTextView;

@property (nonatomic, strong) ETSuggestViewModel *viewModel;

@end

@implementation ETSuggestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.suggestTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(10);
        make.top.equalTo(weakSelf.view).with.offset(10);
        make.right.equalTo(weakSelf.view).with.offset(-10);
        make.height.equalTo(@200);
    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.suggestTextView];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.suggestEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.suggestTextView rac_textSignal] subscribeNext:^(NSString *string) {
        @strongify(self)
        NSLog(@"%@", string);
        if ([string isEqualToString:@""]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.viewModel.suggest = string;
        }
    }];
}

- (void)et_layoutNavigation {
    self.title = @"意见反馈";
    self.view.backgroundColor = ETMainBgColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
//    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
//    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
//    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithTitle:@"提交"];
    self.navigationItem.rightBarButtonItem.tintColor = ETBlackColor;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    [self.viewModel.suggestCommand execute:nil];
}

#pragma mark -- lazyLoad --

- (UITextView *)suggestTextView {
    if (!_suggestTextView) {
        _suggestTextView = [[UITextView alloc] init];
        _suggestTextView.backgroundColor = ETMinorBgColor;
        _suggestTextView.textColor = ETTextColor_First;
        _suggestTextView.font = [UIFont systemFontOfSize:14];
        _suggestTextView.layer.cornerRadius = 10;
    }
    return _suggestTextView;
}

- (ETSuggestViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSuggestViewModel alloc] init];
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
