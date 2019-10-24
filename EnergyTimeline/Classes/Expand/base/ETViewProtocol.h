//
//  ETViewProtocol.h
//  能量圈
//
//  Created by 王斌 on 2017/5/8.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETViewModelProtocol;

@protocol ETViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <ETViewModelProtocol>)viewModel;

- (void)et_bindViewModel;
- (void)et_setupViews;

@end
