//
//  ETCacheTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2018/4/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETCacheTableViewCell.h"
#import "CacheManager.h"

@interface ETCacheTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation ETCacheTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    [super updateConstraints];
}

- (void)setCacheType:(ETCacheType)cacheType {
    switch (cacheType) {
        case ETCacheTypeTrain: {
            self.leftLabel.text = @"清空训练缓存";
            self.rightLabel.text = @"计算中";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CGFloat size = [CacheManager getTrainCachesSizeCount];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.rightLabel.text = [NSString stringWithFormat:@"%.1fM", size];
                });
            });
        }
            break;
        case ETCacheTypeImage: {
            self.leftLabel.text = @"清空图片缓存";
            self.rightLabel.text = @"计算中";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CGFloat size = [CacheManager getCachesSizeCount];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.rightLabel.text = [NSString stringWithFormat:@"%.1fM", size];
                });
            });
        }
            break;
        default:
            break;
    }
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
