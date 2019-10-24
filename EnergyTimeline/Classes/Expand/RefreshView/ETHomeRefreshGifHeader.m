//
//  ETHomeRefreshGifHeader.m
//  能量圈
//
//  Created by 王斌 on 2017/5/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomeRefreshGifHeader.h"

@implementation ETHomeRefreshGifHeader

- (void)prepare {
    [super prepare];
    
    NSMutableArray *gifImages = [NSMutableArray array];
    for (NSInteger i = 1; i < 26; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"et_home_refresh_%ld", (long)i]];
        [gifImages addObject:image];
    }
    
    /** 正在刷新 */
    [self setImages:gifImages duration:1.0 forState:MJRefreshStateRefreshing];
    /** 下拉刷新 */
    [self setImages:gifImages duration:1.0 forState:MJRefreshStatePulling];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
