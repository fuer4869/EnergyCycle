//
//  ETTrainTargetView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainTargetView.h"
#import "ETTrainTargetViewModel.h"
#import "ETTrainTargetHeaderView.h"
#import "ETTrainTargetTableViewCell.h"

#import "ETTrainPopView.h"

@interface ETTrainTargetView () <UITableViewDelegate, UITableViewDataSource, ETTrainPopViewDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETTrainTargetHeaderView *headerView;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) ETTrainTargetViewModel *viewModel;

@end

@implementation ETTrainTargetView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.equalTo(@(kStatusBarHeight + kTopBarHeight));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.topView);
        make.left.equalTo(weakSelf.topView).with.offset(15);
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.bottom.equalTo(weakSelf.nextButton.mas_top);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@60);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETTrainTargetViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.topView];
    [self.topView addSubview:self.backButton];
    [self addSubview:self.mainTableView];
    [self addSubview:self.nextButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.projectGetCommand execute:nil];
    
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.backSubject sendNext:nil];
    }];
    
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"下一步");
        [self.viewModel.trainAddCommand execute:nil];
    }];
}

#pragma mark -- lazyLoad --

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = ETWhiteColor;
    }
    return _topView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:ETLeftArrow_Gray] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.tableHeaderView = self.headerView;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_mainTableView registerNib:NibName(ETTrainTargetTableViewCell) forCellReuseIdentifier:ClassName(ETTrainTargetTableViewCell)];
    }
    return _mainTableView;
}

- (ETTrainTargetHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ETTrainTargetHeaderView alloc] initWithViewModel:self.viewModel];
        _headerView.frame = CGRectMake(0, 0, ETScreenW, 150);
//        _headerView
    }
    return _headerView;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:ETTextColor_Fifth forState:UIControlStateNormal];
//        _nextButton.backgroundColor = ETMarkYellowColor;
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _nextButton.backgroundColor = ETGrayColor;
        _nextButton.enabled = NO;
    }
    return _nextButton;
}

- (ETTrainTargetViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainTargetViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- UITableViewDelegate --

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return self.headerView;
//}

#pragma mark -- UITableViewDataSource --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETTrainTargetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETTrainTargetTableViewCell) forIndexPath:indexPath];
    if (indexPath.row) {
        cell.leftLabel.text = @"背景音乐";
        cell.rightLabel.text = self.viewModel.bgm ? self.viewModel.bgm : @"请选择背景音乐";
    } else {
        cell.leftLabel.text = @"专属教练";
        cell.rightLabel.text = self.viewModel.coach ? self.viewModel.coach : @"请选择教练";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
//    ETTrainPopView *popView = [[ETTrainPopView alloc] initWithTitle:indexPath.row ? @"选择音乐" : @"选择教练" ContentArray:indexPath.row ? @[@"激烈", @"舒缓", @"节奏"] : @[@"海哥", @"熊威", @"尌安"] LeftBtnTitle:@"取消" RightBtnTitle:@"确定"];
    ETTrainPopView *popView = [[ETTrainPopView alloc] initWithTitle:indexPath.row ? @"选择音乐" : @"选择教练" ContentArray:indexPath.row ? @[@"舒缓", @"轻松", @"激情", @"紧张"] : @[@"海哥", @"熊威"] LeftBtnTitle:@"取消" RightBtnTitle:@"确定"];
    self.viewModel.popState = indexPath.row;
    popView.delegate = self;
    [ETWindow addSubview:popView];
}

#pragma mark -- ETTrainPopViewDelegate --

- (void)leftButtonClick:(NSString *)string {
    
}

- (void)rightButtonClick:(NSString *)string {
    if (self.viewModel.popState) {
        [MobClick event:@"ETTrainTargetBGMSelect" attributes:@{@"bgm" : string}];
        self.viewModel.bgm = string;
    } else {
        [MobClick event:@"ETTrainTargetCoachSelect" attributes:@{@"coach" : string}];
        self.viewModel.coach = string;
    }
    if (self.viewModel.bgm && self.viewModel.coach) {
        self.nextButton.backgroundColor = ETMarkYellowColor;
        self.nextButton.enabled = YES;
    }
    [self.mainTableView reloadData];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
