//
//  ETPictureCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPictureCollectionViewCell.h"

@interface ETPictureCollectionViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;


@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation ETPictureCollectionViewCell

- (void)updateConstraints {
    [self addGestureRecognizer:self.longGesture];
    [self addGestureRecognizer:self.panGesture];
    
    [super updateConstraints];
}

- (void)setCamera:(BOOL)camera {
    self.removeButton.hidden = camera;
    self.pictureImageView.contentMode = camera ? UIViewContentModeCenter : UIViewContentModeScaleToFill;
}

- (void)setPicturePath:(NSString *)picturePath {
    if (!picturePath) {
        return;
    }
    
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:picturePath]];
}

- (void)setPicture:(UIImage *)picture {
    if (!picture) {
        return;
    }
    
    [self.pictureImageView setImage:picture];
}

- (IBAction)remove:(id)sender {
    [self.removeSubject sendNext:self.imageID];
}

- (void)Gesture:(UIGestureRecognizer *)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(GesturePressDelegate:)]) {
        [self.delegate GesturePressDelegate:gestureRecognizer];
    }
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(Gesture:)];
//        _longGesture.minimumPressDuration = 1.0;
    }
    return _longGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(Gesture:)];
    }
    return _panGesture;
}

#pragma mark -- lazyLoad --

- (RACSubject *)removeSubject {
    if (!_removeSubject) {
        _removeSubject = [RACSubject subject];
    }
    return _removeSubject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
