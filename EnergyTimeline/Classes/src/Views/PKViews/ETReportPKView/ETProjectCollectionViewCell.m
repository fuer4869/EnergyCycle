//
//  ETProjectCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/8/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectCollectionViewCell.h"


@interface ETProjectCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectStatus;
@property (weak, nonatomic) IBOutlet UIImageView *trainImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation ETProjectCollectionViewCell

- (void)updateConstraints {
    self.containerView.backgroundColor = ETProjectRelatedBGColor;
    self.projectNameLabel.textColor = ETTextColor_First;
    self.lineView.backgroundColor = [ETTextColor_Fifth colorWithAlphaComponent:0.5];
    
    self.projectImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat itemWidth = (ETScreenW - 60) / 3;
    CGRect rect = CGRectMake(0, 0, itemWidth, (itemWidth * 8) / 7);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.borderLayer.path = maskPath.CGPath;
    
    [self.containerView.layer setMask:maskLayer];
    [self.containerView.layer addSublayer:self.borderLayer];
    
    [super updateConstraints];
}

- (void)setModel:(ETPKProjectModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:model.FilePath]];
    if ([model.ProjectTypeID isEqualToString:@"-1"]) {
        [self.projectNameLabel setText:[NSString stringWithFormat:@"%@(自定义)", model.ProjectName]];
    } else {
        [self.projectNameLabel setText:model.ProjectName];
    }
    self.trainImageView.hidden = ![model.Is_Train boolValue];
}

// 判断点击状态来显示边框
//- (void)setSelected:(BOOL)selected {
//    if (selected) {
//        self.borderLayer.lineWidth = 8.f;
//        [self.containerView.layer addSublayer:self.borderLayer];
//    } else {
//        self.borderLayer.lineWidth = 0.f;
//        [self.borderLayer removeFromSuperlayer];
//    }
//    [super setSelected:selected];
//}

- (void)setState:(ETProjectState)state {
    if (!state) {
        return;
    }
    
    _state = state;
    
    switch (state) {
        case ETProjectStateNone: {
            self.borderLayer.lineWidth = 0.f;
        }
            break;
        case ETProjectStateSelect: {
            self.borderLayer.lineWidth = 8.f;
        }
            break;
        default:
            break;
    }
}

#pragma mark -- lazyLoad --

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.frame = self.containerView.bounds;
        _borderLayer.lineWidth = 0.f;
        _borderLayer.strokeColor = ETMarkYellowColor.CGColor;
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _borderLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
