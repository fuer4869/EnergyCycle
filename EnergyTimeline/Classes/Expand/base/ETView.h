//
//  ETView.h
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETViewProtocol.h"

@protocol ETViewDelegate <NSObject>

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;

@end

@interface ETView : UIView <ETViewProtocol>

@property (weak, nonatomic) id<ETViewDelegate> scrollDelegate;

@property (strong, nonatomic) UIScrollView *basicScrollView;

@end
