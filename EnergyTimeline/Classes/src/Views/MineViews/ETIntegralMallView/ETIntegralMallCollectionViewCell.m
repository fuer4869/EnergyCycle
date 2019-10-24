//
//  ETIntegralMallCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETIntegralMallCollectionViewCell.h"

@interface ETIntegralMallCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *refPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@end

@implementation ETIntegralMallCollectionViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMinorBgColor;
    
    self.productNameLabel.textColor = ETTextColor_Second;
    self.refPriceLabel.textColor = ETTextColor_Second;
    
    self.productImageView.clipsToBounds = YES;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETProductDetailsViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    self.productNameLabel.text = viewModel.model.ProductName;
    self.refPriceLabel.text = [NSString stringWithFormat:@"参考价: ¥ %@", viewModel.model.RefPrice];
    self.integralLabel.text = [NSString stringWithFormat:@"%@积分", viewModel.model.Integral];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
