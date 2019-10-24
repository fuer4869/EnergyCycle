//
//  ETDailyPKHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKHeaderView.h"

@interface ETDailyPKHeaderView ()

@property (nonatomic, strong) UIButton *avaterButton;

//@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ETDailyPKHeaderView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETDailyPKHeaderViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)setViewModel:(ETDailyPKHeaderViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    
    _viewModel = viewModel;
    
//    if (self.viewModel.model.ProfilePicture) {
//        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.ProfilePicture]];
//    } else {
//        [self.headImageView setImage:[UIImage imageNamed:ETUserPortrait_Default]];
//    }
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.ProfilePicture] placeholderImage:ETUserPortrait_PlaceHolderImage];
    [self.avaterButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:ETUserPortrait_PlaceHolderImage];

    self.nameLabel.text = self.viewModel.model.NickName;
    self.textLabel.text = @"占领了你的封面";

}

- (void)et_setupViews {
//    [self addSubview:self.headImageView];
    [self addSubview:self.avaterButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.textLabel];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-20);
    }];
    
//    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.nameLabel);
//        make.width.height.equalTo(@40);
//        make.right.equalTo(weakSelf.nameLabel.mas_left).with.offset(-10);
//    }];
    
    [self.avaterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLabel);
        make.width.height.equalTo(@40);
        make.right.equalTo(weakSelf.nameLabel.mas_left).with.offset(-10);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right).with.offset(15);
        make.centerY.equalTo(weakSelf.nameLabel);
    }];
    
    [super updateConstraints];
}

#pragma mark -- lazyLoad --


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
//        _headImageView.layer.cornerRadius = 20;
//        _headImageView.layer.masksToBounds = YES;
//        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _headImageView;
//}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setTextColor:ETMarkYellowColor];
        [_nameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    return _nameLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _textLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
