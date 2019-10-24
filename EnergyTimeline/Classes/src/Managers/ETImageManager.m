//
//  ETImageManager.m
//  能量圈
//
//  Created by 王斌 on 2017/7/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETImageManager.h"

@implementation ETImageManager

static CGRect before;

+ (void)showFullImage:(UIImageView *)originalImageView {
    UIImage *image = originalImageView.image;
    UIView *backgroundView = [[UIView alloc] initWithFrame:ETScreenB];
    
    before = [originalImageView convertRect:originalImageView.bounds toView:ETWindow];
    
    [backgroundView setBackgroundColor:ETBlackColor];
    [backgroundView setAlpha:0];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:before];
    [imageView setImage:image];
    [imageView setTag:1];
    [backgroundView addSubview:imageView];
    
    [ETWindow addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnOriginalImageView:)];
    [backgroundView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0, (ETScreenH - image.size.height * ETScreenW / image.size.width) * 0.5, ETScreenW, image.size.height * ETScreenW / image.size.width);
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)returnOriginalImageView:(UITapGestureRecognizer *)tap {
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        [imageView setFrame:before];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
    
}

@end
