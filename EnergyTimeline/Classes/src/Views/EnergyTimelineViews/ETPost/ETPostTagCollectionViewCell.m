//
//  ETPostTagCollectionViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPostTagCollectionViewCell.h"

static NSString * const tag_gray = @"tag_gray";
static NSString * const tag_yellow = @"tag_yellow";

@interface ETPostTagCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@end

@implementation ETPostTagCollectionViewCell

- (void)updateConstraints {
    
    [super updateConstraints];
}

- (void)setModel:(PostTagModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
    
    [self.tagImageView setImage:[UIImage imageNamed:tag_gray]];
    [self.tagName setTextColor:ETGrayColor];
    self.tagName.text = model.TagName;
}

- (void)setSelected:(BOOL)selected {
    [self.tagImageView setImage:[UIImage imageNamed:(selected ? tag_yellow : tag_gray)]];
    [self.tagName setTextColor:(selected ? [UIColor jk_colorWithHexString:@"F3DB23"] : ETGrayColor)];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
