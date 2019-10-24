//
//  ETProductDetailsTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProductDetailsTableViewCell.h"

@interface ETProductDetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *refPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeExchange;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@end

@implementation ETProductDetailsTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    self.headerImageView.clipsToBounds = YES;
    self.productNameLabel.textColor = ETTextColor_First;
    self.refPriceLabel.textColor = ETTextColor_Third;
    self.tagLabel.textColor = ETTextColor_Third;
    self.briefLabel.textColor = ETTextColor_Third;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETProductDetailsViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    self.productNameLabel.text = viewModel.model.ProductName;
//    self.refPriceLabel.text = [NSString stringWithFormat:@"市场参考价: ¥ %@.00元", viewModel.model.RefPrice];
    // 横线的颜色跟随label字体颜色改变
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", viewModel.model.RefPrice]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.refPriceLabel.attributedText = newPrice;

    self.integralLabel.text = viewModel.model.Integral;
    self.briefLabel.text = viewModel.model.Brief;
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.headerImageView sizeThatFits:size].height;
    totalHeight += [self.productNameLabel sizeThatFits:size].height;
    totalHeight += [self.refPriceLabel sizeThatFits:size].height;
    totalHeight += [self.tagLabel sizeThatFits:size].height;
//    totalHeight += [self.integralLabel sizeThatFits:size].height;
    totalHeight += [self.briefLabel sizeThatFits:size].height;
    totalHeight += 50;
    return CGSizeMake(size.width, totalHeight);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
