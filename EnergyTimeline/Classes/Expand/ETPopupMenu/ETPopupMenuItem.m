//
//  MenuViewItem.m
//  MenuAnimation
//
//  Created by 王斌 on 2017/4/17.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPopupMenuItem.h"

CGFloat const kETPopupItemContentSizeRatio = .4f;

@interface ETPopupMenuItem ()

// 内容图片
@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation ETPopupMenuItem

// 初始化视图
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                 contentImage:(UIImage *)contentImage
      contentHighlightedImage:(UIImage *)contentHighlightedImage {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.image = image;
        self.highlightedImage = highlightedImage;
        
        self.contentImageView.image = contentImage;
        self.contentImageView.highlightedImage = contentHighlightedImage;
        
        [self setupSubviews];
    }
    return self;
}

// 设置视图
- (void)setupSubviews {
    [self addSubview:self.contentImageView];
}

// 布局视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentImageView.jk_width = self.jk_width * kETPopupItemContentSizeRatio;
    self.contentImageView.jk_height = self.jk_height *kETPopupItemContentSizeRatio;
    self.contentImageView.jk_centerX = self.jk_width * 0.5;
    self.contentImageView.jk_centerY = self.jk_height * 0.5;
}

// 点击按钮触发回调事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(popupMenuItemTouchesBegan:)]) {
        [self.delegate popupMenuItemTouchesBegan:self];
    }
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
    }
    return _contentImageView;
}

@end
