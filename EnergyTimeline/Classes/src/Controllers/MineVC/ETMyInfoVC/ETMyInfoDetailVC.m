//
//  ETMyInfoDetailVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMyInfoDetailVC.h"
#import "ETMyInfoDetailTableViewCell.h"

@interface ETMyInfoDetailVC ()

@property (nonatomic, strong) UITextField *detailTextField;

@property (nonatomic, strong) UITextView *detailTextView;

@property (nonatomic, strong) UserModel *model;

@end

@implementation ETMyInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(10);
        make.top.equalTo(weakSelf.view).with.offset(10);
        make.right.equalTo(weakSelf.view).with.offset(-10);
        make.height.equalTo(@40);
    }];
    
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(10);
        make.top.equalTo(weakSelf.view).with.offset(10);
        make.right.equalTo(weakSelf.view).with.offset(-10);
        make.height.equalTo(@200);
    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.detailTextField];
    [self.view addSubview:self.detailTextView];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMainBgColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:ETBlackColor}];
    self.navigationController.navigationBar.layer.shadowColor = ETBlackColor.CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    [self setupRightNavBarWithTitle:@"保存"];
    self.navigationItem.rightBarButtonItem.tintColor = ETBlackColor;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    [self.backSubject sendNext:self.viewModel];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setViewModel:(ETMyInfoTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;

    switch (viewModel.indexPath.row) {
        case 0: {
            self.title = @"昵称";
            self.detailTextField.hidden = NO;
            self.detailTextField.placeholder = @"请输入昵称";
            self.detailTextField.text = viewModel.model.NickName;

        }
            break;
        case 1: {
            self.title = @"姓名";
            self.detailTextField.hidden = NO;
            self.detailTextField.placeholder = @"请输入姓名";
            self.detailTextField.text = viewModel.model.UserName;

        }
            break;
        case 4: {
            self.title = @"邮箱";
            self.detailTextField.hidden = NO;
            self.detailTextField.placeholder = @"请输入邮箱";
            self.detailTextField.text = viewModel.model.Email;

        }
            break;
        case 5: {
            self.title = @"简介";
            self.detailTextView.hidden = NO;
            [self.detailTextView jk_addPlaceHolder:@"暂无简介"];
            self.detailTextView.text = viewModel.model.Brief;
            self.detailTextView.jk_placeHolderTextView.hidden = viewModel.model.Brief ? YES : NO;

        }
            break;
        default:
            break;
    }
    
    self.model = viewModel.model.copy;
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.detailTextField.rac_textSignal subscribeNext:^(NSString *string) {
        @strongify(self)
        NSLog(@"%@", string);
        switch (self.viewModel.indexPath.row) {
            case 0: {
                if ([self.model.NickName isEqualToString:string] || [string isEqualToString:@""]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                } else {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    self.viewModel.model.NickName = string;
                }
            }
                break;
            case 1: {
                if ([self.model.UserName isEqualToString:string] || [string isEqualToString:@""]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                } else {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    self.viewModel.model.UserName = string;
                }
            }
                break;
            case 4: {
                if ([self.model.Email isEqualToString:string] || [string isEqualToString:@""] || ![string jk_isEmailAddress]) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                } else {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    self.viewModel.model.Email = string;
                }
            }
                break;
            default:
                break;
        }
    }];
    
    [[self.detailTextView rac_textSignal] subscribeNext:^(NSString *string) {
        @strongify(self)
        NSLog(@"%@", string);
        if ([self.model.Brief isEqualToString:string] || [string isEqualToString:@""]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.viewModel.model.Brief = string;
        }
    }];
}

#pragma mark -- lazyLoad --

- (UITextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = [[UITextField alloc] init];
        _detailTextField.font = [UIFont systemFontOfSize:14];
        _detailTextField.backgroundColor = ETWhiteColor;
        _detailTextField.layer.cornerRadius = 10;
        _detailTextField.hidden = YES;
    }
    return _detailTextField;
}

- (UITextView *)detailTextView {
    if (!_detailTextView) {
        _detailTextView = [[UITextView alloc] init];
        _detailTextView.font = [UIFont systemFontOfSize:14];
        _detailTextView.layer.cornerRadius = 10;
        _detailTextView.hidden = YES;
    }
    return _detailTextView;
}

- (RACSubject *)backSubject {
    if (!_backSubject) {
        _backSubject = [RACSubject subject];
    }
    return _backSubject;
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
