//
//  ETShareTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETShareTableViewCell.h"

static NSString * const timeline_select = @"share_timeline_select";
static NSString * const timeline_unselected = @"share_timeline_unselected";
static NSString * const wechat_select = @"share_wechat_select";
static NSString * const wechat_unselected = @"share_wechat_unselected";
static NSString * const weibo_select = @"share_weibo_select";
static NSString * const weibo_unselected = @"share_weibo_unselected";
static NSString * const qq_select = @"share_qq_select";
static NSString * const qq_unselected = @"share_qq_unselected";
static NSString * const qzone_select = @"share_qzone_select";
static NSString * const qzone_unselected = @"share_qzone_unselected";

@interface ETShareTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeline;
@property (weak, nonatomic) IBOutlet UIButton *wechat;
@property (weak, nonatomic) IBOutlet UIButton *weibo;
@property (weak, nonatomic) IBOutlet UIButton *qq;
@property (weak, nonatomic) IBOutlet UIButton *qzone;

@end

@implementation ETShareTableViewCell

- (void)updateConstraints {
    self.onTimeline = NO;
    self.onWechat = NO;
    self.onWeibo = NO;
    self.onQQ = NO;
    self.onQzone = NO;
    
    self.shareLabel.textColor = ETTextColor_Second;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETShareTableViewCellViewModel *)viewModel {
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    @weakify(self)
    [[self.timeline rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.onTimeline) {
            [self.timeline setImage:[UIImage imageNamed:timeline_select] forState:UIControlStateNormal];
            self.onTimeline = YES;
        } else {
            [self.timeline setImage:[UIImage imageNamed:timeline_unselected] forState:UIControlStateNormal];
            self.onTimeline = NO;
        }
        [self.viewModel.timelineSubject sendNext:@(self.onTimeline)];
    }];
    
    [[self.wechat rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.onWechat) {
            [self.wechat setImage:[UIImage imageNamed:wechat_select] forState:UIControlStateNormal];
            self.onWechat = YES;
        } else {
            [self.wechat setImage:[UIImage imageNamed:wechat_unselected] forState:UIControlStateNormal];
            self.onWechat = NO;
        }
        [self.viewModel.wechatSubject sendNext:@(self.onWechat)];
    }];
    
    [[self.weibo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.onWeibo) {
            [self.weibo setImage:[UIImage imageNamed:weibo_select] forState:UIControlStateNormal];
            self.onWeibo = YES;
        } else {
            [self.weibo setImage:[UIImage imageNamed:weibo_unselected] forState:UIControlStateNormal];
            self.onWeibo = NO;
        }
        [self.viewModel.weiboSubject sendNext:@(self.onWeibo)];
    }];
    
    [[self.qq rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.onQQ) {
            [self.qq setImage:[UIImage imageNamed:qq_select] forState:UIControlStateNormal];
            self.onQQ = YES;
        } else {
            [self.qq setImage:[UIImage imageNamed:qq_unselected] forState:UIControlStateNormal];
            self.onQQ = NO;
        }
        [self.viewModel.qqSubject sendNext:@(self.onQQ)];
    }];
    
    [[self.qzone rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.onQzone) {
            [self.qzone setImage:[UIImage imageNamed:qzone_select] forState:UIControlStateNormal];
            self.onQzone = YES;
        } else {
            [self.qzone setImage:[UIImage imageNamed:qzone_unselected] forState:UIControlStateNormal];
            self.onQzone = NO;
        }
        [self.viewModel.qzoneSubject sendNext:@(self.onQzone)];
    }];
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
