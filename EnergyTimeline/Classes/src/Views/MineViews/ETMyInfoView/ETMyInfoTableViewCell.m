//
//  ETMyInfoTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMyInfoTableViewCell.h"

@interface ETMyInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation ETMyInfoTableViewCell

- (void)setViewModel:(ETMyInfoTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    switch (viewModel.indexPath.row) {
        case 0: {
            self.leftLabel.text = @"昵称";
            self.rightLabel.text = viewModel.model.NickName ? viewModel.model.NickName : @"请输入昵称";
        }
            break;
        case 1: {
            self.leftLabel.text = @"姓名";
            self.rightLabel.text = viewModel.model.UserName ? viewModel.model.UserName : @"请输入姓名";
        }
            break;
        case 2: {
            self.leftLabel.text = @"性别";
            self.rightLabel.text = viewModel.model.Gender ? ([viewModel.model.Gender isEqualToString:@"2"] ? @"女" : @"男") : @"未确定";
        }
            break;
        case 3: {
            self.leftLabel.text = @"生日";
            self.rightLabel.text = viewModel.model.Birthday ? [viewModel.model.Birthday substringToIndex:10] : @"请输入生日";
        }
            break;
//        case 4: {
//            self.leftLabel.text = @"电话";
//            self.rightLabel.text = viewModel.model.LoginName ? viewModel.model.LoginName : @"未设置手机号";
//        }
//            break;
        case 4: {
            self.leftLabel.text = @"邮箱";
            self.rightLabel.text = viewModel.model.Email ? viewModel.model.Email : @"请输入邮箱";
        }
            break;
        case 5: {
            self.leftLabel.text = @"简介";
            self.rightLabel.text = viewModel.model.Brief ? viewModel.model.Brief : @"暂无简介";
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
