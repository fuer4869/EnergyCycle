//
//  ETOpinionHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETOpinionHeaderView.h"

@interface ETOpinionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;

@end

@implementation ETOpinionHeaderView

- (void)updateConstraints {
    
    
    [self.firstLabel jk_setRoundedCorners:UIRectCornerAllCorners radius:self.firstLabel.jk_height / 2];
    [self.secondLabel jk_setRoundedCorners:UIRectCornerAllCorners radius:self.secondLabel.jk_height / 2];
    [self.thirdLabel jk_setRoundedCorners:UIRectCornerAllCorners radius:self.thirdLabel.jk_height / 2];
    [self.fourthLabel jk_setRoundedCorners:UIRectCornerAllCorners radius:self.fourthLabel.jk_height / 2];

//    self.hintLabel.textColor = ETTextColor_Third;
    
//    self.hintLabel.adjustsFontSizeToFitWidth = YES;
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
