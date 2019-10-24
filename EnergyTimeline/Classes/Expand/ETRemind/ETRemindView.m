//
//  ETRemindView.m
//  能量圈
//
//  Created by 王斌 on 2017/11/1.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRemindView.h"

@interface ETRemindView ()

@property (nonatomic, strong) NSMutableArray *remindImageArr;

@property (nonatomic, strong) UIButton *remindView;

@end

@implementation ETRemindView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.remindView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.remindView.frame = ETWindow.bounds;
    [self.remindView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.remindView.adjustsImageWhenDisabled = NO; // 取消高亮
    [self addSubview:self.remindView];
}

- (void)close {
    if (self.remindImageArr && self.remindImageArr.count > 1) {
        [self.remindImageArr removeObjectAtIndex:0];
        [self.remindView setImage:[UIImage imageNamed:self.remindImageArr[0]] forState:UIControlStateNormal];
    } else {
        if ([self.delegate respondsToSelector:@selector(popViewClickRemindView)]) {
            [self.delegate popViewClickRemindView];
        }
        [self removeFromSuperview];
    }
}

+ (ETRemindView *)remindImageName:(NSString *)imageName {
    ETRemindView *remind = [[ETRemindView alloc] initWithFrame:ETWindow.bounds];
    [remind.remindView setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [ETWindow addSubview:remind];
    return remind;
}

+ (ETRemindView *)remindImageArr:(NSMutableArray *)imageArr {
    if (imageArr && imageArr.count) {
        ETRemindView *remind = [[ETRemindView alloc] initWithFrame:ETWindow.bounds];
        remind.remindImageArr = imageArr;
        [remind.remindView setImage:[UIImage imageNamed:imageArr[0]] forState:UIControlStateNormal];
        [ETWindow addSubview:remind];
        return remind;
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
