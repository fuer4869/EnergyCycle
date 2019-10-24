//
//  ETCacheVC.m
//  能量圈
//
//  Created by 王斌 on 2018/4/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETCacheVC.h"
#import "ETCacheView.h"

@interface ETCacheVC ()

@property (nonatomic, strong) ETCacheView *mainView;

@end

@implementation ETCacheVC

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
    
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETCacheVC"];
    self.title = @"缓存管理";
    self.view.backgroundColor = ETMainBgColor;
    
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETCacheVC"];
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- lazyLoad --

- (ETCacheView *)mainView {
    if (!_mainView) {
        _mainView = [[ETCacheView alloc] init];
    }
    return _mainView;
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
