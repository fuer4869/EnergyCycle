//
//  ETSearchNotFoundTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2018/2/2.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETSearchNotFoundTableViewCell.h"

@interface ETSearchNotFoundTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation ETSearchNotFoundTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.leftLabel.textColor = ETTextColor_First;
    
    [super updateConstraints];
}

- (void)setViewModel:(ETSearchProjectViewModel *)viewModel {
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.leftLabel.text = [NSString stringWithFormat:@"未找到习惯\"%@\"", viewModel.searchKey];
}

- (IBAction)newProject:(id)sender {
    [self.viewModel.newProejctSubject sendNext:nil];
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
