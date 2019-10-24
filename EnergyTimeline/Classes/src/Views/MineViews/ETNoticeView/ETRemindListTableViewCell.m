//
//  ETRemindListTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRemindListTableViewCell.h"

static NSString * const fans = @"mine_remind_fans";
static NSString * const comment = @"mine_remind_comment";
static NSString * const like = @"mine_remind_like";
static NSString * const mention = @"mine_remind_mention";
static NSString * const notice = @"mine_remind_notice";

@interface ETRemindListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIButton *unRead;

@end

@implementation ETRemindListTableViewCell

- (void)updateConstraints {
    
    self.unRead.backgroundColor = ETRedColor;
    self.unRead.layer.cornerRadius = self.unRead.jk_height / 2;
    self.unRead.clipsToBounds = YES;
    
    [super updateConstraints];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    
    _indexPath = indexPath;
    
    switch (indexPath.row) {
        case 0: {
            [self.leftImageView setImage:[UIImage imageNamed:fans]];
            self.leftLabel.text = @"新粉丝";
            [self.unRead setTitle:self.model.NewFriend forState:UIControlStateNormal];
            self.unRead.hidden = ![self.model.NewFriend integerValue];
        }
            break;
        case 1: {
            [self.leftImageView setImage:[UIImage imageNamed:comment]];
            self.leftLabel.text = @"评论";
            [self.unRead setTitle:self.model.Post_Commen forState:UIControlStateNormal];
            self.unRead.hidden = ![self.model.Post_Commen integerValue];
        }
            break;
        case 2: {
            [self.leftImageView setImage:[UIImage imageNamed:like]];
            self.leftLabel.text = @"喜欢";
            [self.unRead setTitle:self.model.Post_Like forState:UIControlStateNormal];
            self.unRead.hidden = ![self.model.Post_Like integerValue];
        }
            break;
        case 3: {
            [self.leftImageView setImage:[UIImage imageNamed:mention]];
            self.leftLabel.text = @"提到我";
            [self.unRead setTitle:self.model.Post_MenTion forState:UIControlStateNormal];
            self.unRead.hidden = ![self.model.Post_MenTion integerValue];
        }
            break;
        case 4: {
            [self.leftImageView setImage:[UIImage imageNamed:notice]];
            self.leftLabel.text = @"通知";
            [self.unRead setTitle:self.model.Notice forState:UIControlStateNormal];
            self.unRead.hidden = ![self.model.Notice integerValue];
        }
            break;
        default:
            break;
    }
}

- (void)setModel:(NoticeNotReadModel *)model {
    if (!model) {
        return;
    }
    
    _model = model;
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
