//
//  ETAboutHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/20.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETAboutHeaderView.h"

@interface ETAboutHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *appLabel;

@end

@implementation ETAboutHeaderView

- (void)updateConstraints {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    // 获取App的build版本
//    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    // 获取App的名称
//    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    
    self.appLabel.text = [NSString stringWithFormat:@"能量圈%@", appVersion];
    self.appLabel.textColor = ETTextColor_Second;
    
    self.backgroundColor = ETClearColor;
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
