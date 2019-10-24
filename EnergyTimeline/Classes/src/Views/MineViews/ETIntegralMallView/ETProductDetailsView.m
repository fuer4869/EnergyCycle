//
//  ETProductDetailsView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProductDetailsView.h"
#import "ETProductDetailsViewModel.h"
#import "ETProductDetailsTableViewCell.h"

#import "ETPopView.h"

@interface ETProductDetailsView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UILabel *integralLabel;

@property (nonatomic, strong) UIButton *exchangeButton;

@property (nonatomic, strong) ETProductDetailsViewModel *viewModel;

@end

@implementation ETProductDetailsView

//FFA327
- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).with.offset(-60);
    }];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(40);
        make.centerY.equalTo(weakSelf.exchangeButton);
        make.width.equalTo(@100);
    }];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(weakSelf);
//        make.top.equalTo(weakSelf.mainTableView.mas_bottom);
        make.left.equalTo(weakSelf.integralLabel.mas_right).with.offset(25);
        make.right.equalTo(weakSelf).with.offset(-15);
        make.bottom.equalTo(weakSelf).with.offset(-5);
        make.height.equalTo(@55);
    }];
    
    self.exchangeButton.layer.cornerRadius = 55.f / 2;

    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETProductDetailsViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    [self addSubview:self.integralLabel];
    [self addSubview:self.exchangeButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
//    @weakify(self)
//    [self.viewModel.refreshDataCommand execute:nil];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:NibName(ETProductDetailsTableViewCell) forCellReuseIdentifier:ClassName(ETProductDetailsTableViewCell)];
    }
    return _mainTableView;
}

- (UILabel *)integralLabel {
    if (!_integralLabel) {
        _integralLabel  = [[UILabel alloc] init];
//        _integralLabel.text = self.viewModel.model.Integral;
        _integralLabel.textColor = [UIColor jk_colorWithHexString:@"FFA327"];
        _integralLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@积分", self.viewModel.model.Integral]];
        [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold]} range:NSMakeRange(0, string.length - 2)];
        [string addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:10]} range:NSMakeRange(string.length - 2, 2)];
        _integralLabel.attributedText = string;
    }
    return _integralLabel;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [[UIButton alloc] init];
//        _exchangeButton.backgroundColor = [UIColor jk_colorWithHexString:@"F24D4C"];
        _exchangeButton.backgroundColor = ETMinorColor;
        [_exchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        [_exchangeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_exchangeButton setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        @weakify(self)
        [[_exchangeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if ([self.viewModel.model.Integral integerValue] > [self.viewModel.userModel.Integral integerValue]) {
                [ETPopView popViewWithTitle:@"积分不足" Tip:@"您的积分余额不足"];
            } else {
                [self.viewModel.exchangeSubject sendNext:nil];
            }
        }];
    }
    return _exchangeButton;
}

- (ETProductDetailsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProductDetailsViewModel alloc] init];
    }
    return _viewModel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.model ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETProductDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETProductDetailsTableViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:ClassName(ETProductDetailsTableViewCell) configuration:^(ETProductDetailsTableViewCell *cell) {
        cell.fd_enforceFrameLayout = NO;
        cell.viewModel = self.viewModel;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
