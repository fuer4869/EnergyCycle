//
//  ETInviteTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/5.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETInviteTableViewCell.h"

static NSString * const timeline = @"share_wechatTimeline_round";
static NSString * const wechat = @"share_wechatSession_round";
static NSString * const weibo = @"share_sinaWeibo_round";
static NSString * const qq = @"share_qq_round";
static NSString * const qzone = @"share_qzone_round";
static NSString * const addressBook = @"addressBook_round";

@interface ETInviteTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;

@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation ETInviteTableViewCell

- (void)setShareType:(ETShareType)shareType {
    
    self.backgroundColor = ETMinorBgColor;
    self.shareLabel.textColor = ETTextColor_Second;
    self.bottomLine.backgroundColor = ETMainLineColor;
    
    switch (shareType) {
        case ETShareTimeline: {
            [self.shareImageView setImage:[UIImage imageNamed:timeline]];
            self.shareLabel.text = @"邀请朋友圈好友";
        }
            break;
        case ETShareWechat: {
            [self.shareImageView setImage:[UIImage imageNamed:wechat]];
            self.shareLabel.text = @"邀请微信好友";
        }
            break;
        case ETShareWeibo: {
            [self.shareImageView setImage:[UIImage imageNamed:weibo]];
            self.shareLabel.text = @"邀请微博好友";
        }
            break;
        case ETShareQQ: {
            [self.shareImageView setImage:[UIImage imageNamed:qq]];
            self.shareLabel.text = @"邀请QQ好友";
        }
            break;
        case ETShareQzone: {
            [self.shareImageView setImage:[UIImage imageNamed:qzone]];
            self.shareLabel.text = @"邀请QQ空间好友";
            self.bottomLine.hidden = YES;
        }
            break;
        case ETShareAddressBook: {
            [self.shareImageView setImage:[UIImage imageNamed:addressBook]];
            self.shareLabel.text = @"邀请通讯录好友";
            self.bottomLine.hidden = YES;
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
