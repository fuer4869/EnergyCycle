//
//  ETSyncPostTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSyncPostTableViewCell.h"

static NSString * const post_select = @"app_logo_select";
static NSString * const post_unselected = @"app_logo_unselected";

@interface ETSyncPostTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *syncPost;

@property (nonatomic, assign) BOOL onSync;

@end

@implementation ETSyncPostTableViewCell

- (void)updateConstraints {
    self.onSync = NO;
    [super updateConstraints];
}

- (void)setViewModel:(ETSyncPostTableViewCellViewModel *)viewModel {
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    @weakify(self)
    [[self.syncPost rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (!self.onSync) {
            [self.syncPost setImage:[UIImage imageNamed:post_select] forState:UIControlStateNormal];
            self.onSync = YES;
        } else {
            [self.syncPost setImage:[UIImage imageNamed:post_unselected] forState:UIControlStateNormal];
            self.onSync = NO;
        }
        [self.viewModel.syncSubject sendNext:@(self.onSync)];
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
