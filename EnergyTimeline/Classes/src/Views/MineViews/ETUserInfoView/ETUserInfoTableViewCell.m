//
//  ETUserInfoTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/10/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUserInfoTableViewCell.h"

static NSString * const userInfo_portrait = @"mine_userInfo_portrait_gray_round";
static NSString * const userInfo_nickName = @"mine_userInfo_nickName_gray_round";
static NSString * const userInfo_birthday = @"mine_userInfo_birthday_gray_round";
static NSString * const userInfo_gender = @"mine_userInfo_gender_gray_round";
static NSString * const userInfo_email = @"mine_userInfo_email_gray_round";
static NSString * const userInfo_brief = @"mine_userInfo_brief_gray_round";

static NSString * const userInfo_portrait_black = @"mine_userInfo_portrait_black_round";
static NSString * const userInfo_nickName_black = @"mine_userInfo_nickName_black_round";
static NSString * const userInfo_birthday_black = @"mine_userInfo_birthday_black_round";
static NSString * const userInfo_gender_black = @"mine_userInfo_gender_black_round";
static NSString * const userInfo_email_black = @"mine_userInfo_email_black_round";
static NSString * const userInfo_brief_black = @"mine_userInfo_brief_black_round";

static NSString * const man_selected = @"gender_man_blue_selected";
static NSString * const man_unselected = @"gender_man_blue_unselected";
static NSString * const woman_selected = @"gender_woman_red_selected";
static NSString * const woman_unselected = @"gender_woman_red_unselected";


@interface ETUserInfoTableViewCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *womenButton;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ETUserInfoTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.titleLabel.textColor = ETTextColor_Fourth;
    self.textField.textColor = ETTextColor_Fourth;
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName : ETTextColor_Third}];
    self.textField.attributedPlaceholder = placeholder;
    self.textView.backgroundColor = ETClearColor;

    
    [super updateConstraints];
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    NSInteger index = 0;
    switch (indexPath.row) {
        case 0: {
            identifier = @"UserInfoTableViewCellFirst";
            index = 0;
        }
            break;
        case 1: {
            identifier = @"UserInfoTableViewCellSecond";
            index = 1;
        }
            break;
        case 2: {
            identifier = @"UserInfoTableViewCellSecond";
            index = 1;
        }
            break;
        case 3: {
            identifier = @"UserInfoTableViewCellThird";
            index = 2;
        }
            break;
        case 4: {
            identifier = @"UserInfoTableViewCellSecond";
            index = 1;
        }
            break;
        case 5: {
            identifier = @"UserInfoTableViewCellFourth";
            index = 3;
        }
            break;
        default:
            break;
    }
    ETUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETUserInfoTableViewCell) owner:self options:nil] objectAtIndex:index];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        switch (indexPath.row) {
            case 1: {
                [cell.textField.rac_textSignal subscribeNext:^(NSString *string) {
                    cell.viewModel.model.NickName = string;
                }];
            }
                break;
            case 4: {
                [cell.textField.rac_textSignal subscribeNext:^(NSString *string) {
                    cell.viewModel.model.Email = string;
                }];
            }
                break;
            case 5: {
                [cell.textView.rac_textSignal subscribeNext:^(NSString *string) {
                    cell.viewModel.model.Brief = string;
                }];
            }
            default:
                break;
        }

    }
    return cell;
}

- (void)setViewModel:(ETUserInfoViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    switch (self.indexPath.row) {
        case 0: {
            [self.iconImageView setImage:[UIImage imageNamed:userInfo_portrait_black]];
            self.titleLabel.text = @"头像";
            self.profilePictureButton.layer.cornerRadius = self.profilePictureButton.jk_height / 2;
            self.profilePictureButton.layer.masksToBounds = YES;
            if (viewModel.image) {
                [self.profilePictureButton setImage:viewModel.image forState:UIControlStateNormal];
            } else {
                [self.profilePictureButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ETUserCoverImg_Default]];
            }
        }
            break;
        case 1: {
            [self.iconImageView setImage:[UIImage imageNamed:userInfo_nickName_black]];
            self.titleLabel.text = @"昵称";
            self.textField.text = viewModel.model.NickName;
        }
            break;
        case 2: {
            [self.iconImageView setImage:[UIImage imageNamed:userInfo_birthday_black]];
            self.titleLabel.text = @"生日";
            self.textField.text = viewModel.model.Birthday ? [viewModel.model.Birthday substringToIndex:10] : @"";
            self.textField.enabled = NO;
        }
            break;
        case 3: {
            [self.iconImageView setImage:[UIImage imageNamed:userInfo_gender_black]];
            self.titleLabel.text = @"性别";
            [self.manButton setImage:[UIImage imageNamed:[viewModel.model.Gender isEqualToString:@"1"] ? man_selected : man_unselected] forState:UIControlStateNormal];
            [self.womenButton setImage:[UIImage imageNamed:[viewModel.model.Gender isEqualToString:@"2"] ? woman_selected : woman_unselected] forState:UIControlStateNormal];
        }
            break;
        case 4: {
            [self.iconImageView setImage:[UIImage imageNamed:userInfo_email_black]];
            self.titleLabel.text = @"邮箱";
            self.textField.text = viewModel.model.Email;
        }
            break;
        case 5: {
            [self.iconImageView setImage:[UIImage imageNamed:userInfo_brief_black]];
            self.titleLabel.text = @"简介";
            self.textView.text = viewModel.model.Brief;
            [self.textView jk_addPlaceHolder:@"请输入你的签名......"];
            self.textView.jk_placeHolderTextView.textColor = [UIColor colorWithHexString:@"95A0AB"];
            self.textView.jk_placeHolderTextView.hidden = viewModel.model.Brief ? YES : NO;
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)profilePicture:(id)sender {
    [self.viewModel.profilePictureSubject sendNext:nil];
}

- (IBAction)woman:(id)sender {
    self.viewModel.model.Gender = @"2";
    [self.manButton setImage:[UIImage imageNamed:[self.viewModel.model.Gender isEqualToString:@"1"] ? man_selected : man_unselected] forState:UIControlStateNormal];
    [self.womenButton setImage:[UIImage imageNamed:[self.viewModel.model.Gender isEqualToString:@"2"] ? woman_selected : woman_unselected] forState:UIControlStateNormal];
}

- (IBAction)man:(id)sender {
    self.viewModel.model.Gender = @"1";
    [self.manButton setImage:[UIImage imageNamed:[self.viewModel.model.Gender isEqualToString:@"1"] ? man_selected : man_unselected] forState:UIControlStateNormal];
    [self.womenButton setImage:[UIImage imageNamed:[self.viewModel.model.Gender isEqualToString:@"2"] ? woman_selected : woman_unselected] forState:UIControlStateNormal];
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
