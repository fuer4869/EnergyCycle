//
//  ETPhotoCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPhotoCollectionViewCell.h"

@interface ETPhotoCollectionViewCell ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end

@implementation ETPhotoCollectionViewCell

- (void)updateConstraints {
    [self addGestureRecognizer:self.longGesture];
    
    [super updateConstraints];
}

- (void)setPhoto:(UIImage *)photo {
    if (!photo) {
        return;
    }
    
    [self.photoImage setImage:photo];
}

- (void)longpressGesture:(UILongPressGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didLongpressedPhoto:)]) {
        [self.delegate didLongpressedPhoto:self.index];
    }
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressGesture:)];
        _longGesture.minimumPressDuration = 1.0;
    }
    return _longGesture;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
