//
//  ETView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETView.h"

@interface ETView () <UIScrollViewDelegate>

@end

@implementation ETView

- (instancetype)init {
    if (self = [super init]) {
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    if (self = [super init]) {
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

- (void)et_setupViews {};

- (void)et_bindViewModel {};

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_basicScrollView) {
        _basicScrollView = scrollView;
    }
    
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.scrollDelegate scrollViewIsScrolling:scrollView];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
