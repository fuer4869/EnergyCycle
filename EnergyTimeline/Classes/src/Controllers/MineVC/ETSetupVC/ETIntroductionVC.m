//
//  ETIntroductionVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntroductionVC.h"

@interface ETIntroductionVC ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ETIntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel.textColor = ETTextColor_Third;
    // Do any additional setup after loading the view from its nib.
}

- (void)et_layoutNavigation {
    self.title = @"功能介绍";
    self.view.backgroundColor = ETMainBgColor;
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
