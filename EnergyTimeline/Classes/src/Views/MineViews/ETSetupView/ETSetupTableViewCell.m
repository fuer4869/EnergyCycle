//
//  ETSetupTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSetupTableViewCell.h"

static NSString * const setup_userData = @"mine_setup_userData_gray_round";
static NSString * const setup_phone = @"mine_setup_phone_gray_round";
static NSString * const setup_suggest = @"mine_setup_suggest_gray_round";
static NSString * const setup_cache = @"mine_setup_cache_gray_round";
static NSString * const setup_notification = @"mine_setup_notification_gray_round";
static NSString * const setup_about = @"mine_setup_about_gray_round";

static NSString * const setup_userData_black = @"mine_setup_userData_black_round";
static NSString * const setup_phone_black = @"mine_setup_phone_black_round";
static NSString * const setup_suggest_black = @"mine_setup_suggest_black_round";
static NSString * const setup_cache_black = @"mine_setup_cache_black_round";
static NSString * const setup_notification_black = @"mine_setup_notification_black_round";
static NSString * const setup_about_black = @"mine_setup_about_black_round";

@interface ETSetupTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation ETSetupTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.containerView.backgroundColor = ETClearColor;
    self.leftLabel.textColor = ETTextColor_Fourth;
    self.lineView.backgroundColor = ETMainLineColor;
    
    [super updateConstraints];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    
    _indexPath = indexPath;
    
    switch (indexPath.row) {
        case 0: {
            [self.leftImageView setImage:[UIImage imageNamed:setup_userData_black]];
            self.leftLabel.text = @"个人资料";
        }
            break;
        case 1: {
            [self.leftImageView setImage:[UIImage imageNamed:setup_phone_black]];
            self.leftLabel.text = @"更换手机号";
        }
            break;
        case 2: {
            [self.leftImageView setImage:[UIImage imageNamed:setup_suggest_black]];
            self.leftLabel.text = @"意见反馈";
        }
            break;
        case 3: {
            [self.leftImageView setImage:[UIImage imageNamed:setup_cache_black]];
            self.leftLabel.text = @"缓存管理";
        }
            break;
        case 4: {
            [self.leftImageView setImage:[UIImage imageNamed:setup_notification_black]];
            self.leftLabel.text = @"消息推送";
            self.rightLabel.text = [self isAllowedNotification] ? @"已开启" : @"未开启";
            self.rightLabel.hidden = NO;
            self.arrowImageView.hidden = YES;
        }
            break;
        case 5: {
            [self.leftImageView setImage:[UIImage imageNamed:setup_about_black]];
            self.leftLabel.text = @"关于能量圈";
            self.lineView.hidden = YES;
        }
            break;
        default:
            break;
    }
    
}

// 获取应用通知开关状态
- (BOOL)isAllowedNotification
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
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
