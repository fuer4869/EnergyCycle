//
//  ETMineTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineTableViewCell.h"

#import "ETPopView.h"

static NSString * const energySource = @"mine_energySource_blue";
static NSString * const energySource_Gray = @"mine_energySource_gray";

static NSString * const setup = @"mine_setup_blue";
static NSString * const charts = @"mine_charts_blue";
static NSString * const charts_Gray = @"mine_charts_gray";
static NSString * const integralRank = @"mine_integralRank_blue";
static NSString * const integralRank_Gray = @"mine_integralRank_gray";
static NSString * const integralRule = @"mine_integralRule_blue";
static NSString * const integralRule_Gray = @"mine_integralRule_gray";

static NSString * const integralMall = @"mine_integralMall_blue";
static NSString * const integralMall_Gray = @"mine_integralMall_gray";

static NSString * const badge = @"mine_badge_blue";
static NSString * const badge_Gray = @"mine_badge_gray";

static NSString * const copy = @"mine_copy_blue";
static NSString * const copy_Gray = @"mine_copy_gray";

static NSString * const opinion_Gray = @"mine_opinion_gray";

static NSString * const personReport_Gray = @"mine_personReport_gray";

@interface ETMineTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *optionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *optionsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *energySourceLabel;
@property (weak, nonatomic) IBOutlet UIView *hintView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIView *underline;

@end

@implementation ETMineTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    self.containerView.backgroundColor = ETClearColor;
    self.optionsNameLabel.textColor = ETTextColor_Second;
    self.energySourceLabel.textColor = ETTextColor_Second;
    self.underline.backgroundColor = ETMainLineColor;
//    self.layer.shadowColor = ETMinorColor.CGColor;
//    self.layer.shadowOpacity = 0.1;
//    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.hintView.layer.cornerRadius = self.hintView.jk_height / 2;
    self.hintView.layer.masksToBounds = YES;
    self.hintView.hidden = YES;
    
    [super updateConstraints];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    
    _indexPath = indexPath;
    
    switch (indexPath.row) {
        case 0: {
            [self.optionsImageView setImage:[UIImage imageNamed:energySource_Gray]];
            [self.optionsNameLabel setText:@"我的能量源"];
            self.energySourceLabel.hidden = NO;
//            [self.arrowImageView setImage:[UIImage imageNamed:copy_Gray]];
            [self.arrowButton setImage:[UIImage imageNamed:copy_Gray] forState:UIControlStateNormal];
            self.arrowButton.userInteractionEnabled = YES;
        }
            break;
        case 1 : {
            [self.optionsImageView setImage:[UIImage imageNamed:integralRule_Gray]];
            [self.optionsNameLabel setText:@"积分攻略"];
        }
            break;
        case 2: {
            [self.optionsImageView setImage:[UIImage imageNamed:badge_Gray]];
            [self.optionsNameLabel setText:@"我的徽章"];
        }
            break;
        case 3: {
//            [self.optionsImageView setImage:[UIImage imageNamed:integralRank_Gray]];
//            [self.optionsNameLabel setText:@"排行榜"];
            NSString *function = [[NSUserDefaults standardUserDefaults] objectForKey:@"New_Function_Mine_Opinion"];
            self.hintView.hidden = [function isEqualToString:@"read"];
            [self.optionsImageView setImage:[UIImage imageNamed:opinion_Gray]];
            [self.optionsNameLabel setText:@"我要吐槽"];
        }
            break;
        case 4: {
            [self.optionsImageView setImage:[UIImage imageNamed:integralMall_Gray]];
            [self.optionsNameLabel setText:@"积分商城"];
        }
            break;
        case 5: {
            [self.optionsImageView setImage:[UIImage imageNamed:charts_Gray]];
            [self.optionsNameLabel setText:@"数据曲线"];
//            self.underline.hidden = YES;
        }
            break;
        case 6 : {
            NSString *function = [[NSUserDefaults standardUserDefaults] objectForKey:@"New_Function_Mine_PersonReport"];
            self.hintView.hidden = [function isEqualToString:@"read"];
            [self.optionsImageView setImage:[UIImage imageNamed:personReport_Gray]];
            [self.optionsNameLabel setText:@"汇总报告"];
            self.underline.hidden = YES;
        }
            break;
        default:
            break;
    }
    
}

- (void)setViewModel:(ETMineViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
    self.energySourceLabel.text = viewModel.model.InviteCode;
}

- (IBAction)pastboard:(id)sender {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.viewModel.model.InviteCode;
    [ETPopView popViewWithTip:@"已复制能量源"];
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
