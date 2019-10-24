//
//  ETViewControllerProtocol.h
//  能量圈
//
//  Created by 王斌 on 2017/5/9.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETViewModelProtocol;

@protocol ETViewControllerProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <ETViewModelProtocol>)viewModel;

- (void)et_bindViewModel;
- (void)et_addSubviews;
- (void)et_layoutNavigation;
- (void)et_getNewData;
- (void)et_didAppear;
- (void)et_willDisappear;
- (void)et_didDisappear;

@end
