//
//  ETDraftsTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDraftsTableViewCell.h"

@interface ETDraftsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextLeftDistance;

@end

@implementation ETDraftsTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
    self.containerView.layer.shadowOpacity = 0.1;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.firstImageView.clipsToBounds = YES;
    
    self.resendButton.layer.cornerRadius = self.resendButton.jk_height / 2;
    [self.resendButton.layer setBorderWidth:1];
    [self.resendButton.layer setBorderColor:[UIColor colorWithHexString:@"F14D3C"].CGColor];
    
    [super updateConstraints];
}

- (void)setViewModel:(ETDraftsTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.timeLabel.text = viewModel.model.time;
    
    self.contextLabel.text = viewModel.model.context;
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *newFielPath = [documentsPath stringByAppendingPathComponent:viewModel.model.imgLocalURL];
    NSArray *content = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@.plist",newFielPath]];
    if ([content firstObject]) {
        [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:[content firstObject]]];
    } else {
        self.firstImageView.hidden = YES;
        self.contextLeftDistance.constant = 18;
    }
}

- (IBAction)resend:(id)sender {
    [self.viewModel.resendSubject sendNext:self.viewModel.model];
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
