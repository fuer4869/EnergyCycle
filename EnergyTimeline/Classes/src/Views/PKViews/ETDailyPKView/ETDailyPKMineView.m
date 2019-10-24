//
//  ETDailyPKMineView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKMineView.h"

static NSString * const submitImage = @"pk_fillIn_yellow";
static NSString * const setupImage = @"pk_setup_yellow";
static NSString * const likeImage = @"like_red";
static NSString * const dislikeImage = @"like_gray";

@interface ETDailyPKMineView ()

@property (nonatomic, strong) UIButton *containerView;

@property (nonatomic, strong) UILabel *rankingLabel;

@property (nonatomic, strong) UIButton *avaterButton;

//@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *numberLabel;
//@property (nonatomic, strong) UILabel *likeLabel;
//@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *setupButton;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger likes;

@end

@implementation ETDailyPKMineView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETDailyPKMineViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)setViewModel:(ETDailyPKMineViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    _viewModel = viewModel;
    
    self.isLike = [self.viewModel.model.Is_Like boolValue];
    
//    if (viewModel.model.ProfilePicture) {
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture]];
//    } else {
//        [self.headImageView setImage:[UIImage imageNamed:ETUserPortrait_Default]];
//    }
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    
    
    [self.avaterButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:ETUserPortrait_PlaceHolderImage];
    
//    self.nameLabel.text = viewModel.model.NickName;
    
    if ([viewModel.model.Limit isEqualToString:@"1"]) {
        self.rankingLabel.hidden = NO;
        self.numberLabel.hidden = NO;
        self.rankingLabel.text = [self.viewModel.model.Report_Days integerValue] ? [NSString stringWithFormat:@"%@.", self.viewModel.model.Ranking] : @"";
        self.numberLabel.text = [self.viewModel.model.Report_Days integerValue] ? [NSString stringWithFormat:@"%@%@", viewModel.model.Report_Days, viewModel.model.ProjectUnit] : @"";
        self.likes = [self.viewModel.model.Likes integerValue];
    } else {
        if ([self.viewModel.model.ReportNum integerValue]) {
            self.rankingLabel.hidden = NO;
            self.numberLabel.hidden = NO;
            self.rankingLabel.text = [NSString stringWithFormat:@"%@.", self.viewModel.model.Ranking];
            if ([self.viewModel.model.ReportNum integerValue] > [self.viewModel.model.Limit integerValue]) {
                self.numberLabel.text = [NSString stringWithFormat:@"%@+%@", self.viewModel.model.Limit, self.viewModel.model.ProjectUnit];
            } else {
                self.numberLabel.text = [NSString stringWithFormat:@"%@%@", self.viewModel.model.ReportNum, self.viewModel.model.ProjectUnit];
            }
            self.likes = [self.viewModel.model.Likes integerValue];
        } else {
            self.rankingLabel.hidden = YES;
            self.numberLabel.hidden = YES;
        }
    }
}

- (void)et_setupViews {
    [self addSubview:self.containerView];
    [self addSubview:self.rankingLabel];
    [self addSubview:self.avaterButton];
//    [self addSubview:self.headImageView];
//    [self addSubview:self.nameLabel];
    [self addSubview:self.numberLabel];
//    [self addSubview:self.likeLabel];
//    [self addSubview:self.likeButton];
    [self addSubview:self.submitButton];
    [self addSubview:self.setupButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.top.equalTo(weakSelf).with.offset(5);
        make.right.equalTo(weakSelf.setupButton.mas_left).with.offset(-10);
        make.bottom.equalTo(weakSelf).with.offset(-5);
    }];
    
//    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(30);
//        make.centerY.equalTo(weakSelf.containerView);
//        make.width.height.equalTo(@40);
//    }];
    
    [self.rankingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(12);
        make.centerY.equalTo(weakSelf.containerView);
    }];

    [self.avaterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(30);
        make.centerY.equalTo(weakSelf.containerView);
        make.width.height.equalTo(@40);
    }];
    
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.headImageView.mas_right).with.offset(10);
//        make.centerY.equalTo(weakSelf.headImageView);
//    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.submitButton.mas_left).with.offset(-45);
        make.centerY.equalTo(weakSelf.avaterButton);
    }];
    
//    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.likeButton);
//        make.bottom.equalTo(weakSelf.likeButton.mas_top);
//    }];
    
//    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.submitButton.mas_left);
//        make.top.equalTo(weakSelf.containerView).with.offset(20);
//        make.bottom.equalTo(weakSelf.containerView);
//        make.width.equalTo(@40);
//    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.containerView);
    }];
    
    [self.setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-10);
        make.top.equalTo(weakSelf).with.offset(5);
        make.bottom.equalTo(weakSelf).with.offset(-5);
        make.width.equalTo(@60);
    }];
    
    [super updateConstraints];
}

- (UIButton *)containerView {
    if (!_containerView) {
        _containerView = [[UIButton alloc] init];
        _containerView.backgroundColor = ETBlackColor;
        _containerView.alpha = 0.6;
        _containerView.layer.cornerRadius = 30;
        @weakify(self)
        [[_containerView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.homePageSubject sendNext:self.viewModel.model.UserID];
        }];
    }
    return _containerView;
}

- (UILabel *)rankingLabel {
    if (!_rankingLabel) {
        _rankingLabel = [[UILabel alloc] init];
        [_rankingLabel setTextColor:ETWhiteColor];
        [_rankingLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _rankingLabel;
}

- (UIButton *)avaterButton {
    if (!_avaterButton) {
        _avaterButton = [[UIButton alloc] init];
        _avaterButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _avaterButton.layer.cornerRadius = 20;
        _avaterButton.clipsToBounds = YES;
        @weakify(self)
        [[_avaterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.homePageSubject sendNext:self.viewModel.model.UserID];
        }];
    }
    return _avaterButton;
}

//- (UIImageView *)headImageView {
//    if (!_headImageView) {
//        _headImageView = [[UIImageView alloc] init];
////        [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.ProfilePicture]];
//        _headImageView.layer.cornerRadius = 20;
//        _headImageView.layer.masksToBounds = YES;
//        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _headImageView;
//}

//- (UILabel *)nameLabel {
//    if (!_nameLabel) {
//        _nameLabel = [[UILabel alloc] init];
//        [_nameLabel setTextColor:ETWhiteColor];
//        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
//    }
//    return _nameLabel;
//}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setTextColor:ETWhiteColor];
        [_numberLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _numberLabel;
}

//- (UILabel *)likeLabel {
//    if (!_likeLabel) {
//        _likeLabel = [[UILabel alloc] init];
//        [_likeLabel setTextColor:ETWhiteColor];
//        [_likeLabel setFont:[UIFont systemFontOfSize:10]];
//    }
//    return _likeLabel;
//}

//- (UIButton *)likeButton {
//    if (!_likeButton) {
//        _likeButton = [[UIButton alloc] init];
//        @weakify(self)
//        [[_likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(self)
//            [self.viewModel.likeClickSubject sendNext:self.viewModel.model.ReportID];
//            self.isLike = !self.isLike;
//            self.likes += self.isLike ? 1 : (-1);
//            self.likeLabel.text = [NSString stringWithFormat:@"%d", self.likes];
//            [_likeButton setImage:[UIImage imageNamed:(self.isLike ? likeImage : dislikeImage)] forState:UIControlStateNormal];
//        }];
//    }
//    return _likeButton;
//}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        [_submitButton setImage:[UIImage imageNamed:submitImage] forState:UIControlStateNormal];
        @weakify(self)
        [[_submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.submitSubject sendNext:nil];
        }];
    }
    return _submitButton;
}

- (UIButton *)setupButton {
    if (!_setupButton) {
        _setupButton = [[UIButton alloc] init];
        [_setupButton setImage:[UIImage imageNamed:setupImage] forState:UIControlStateNormal];
        _setupButton.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.6];
        _setupButton.layer.cornerRadius = 30;
        @weakify(self)
        [[_setupButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.setupSubject sendNext:nil];
        }];
    }
    return _setupButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
