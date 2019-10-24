//
//  ETTrainCompleteView.m
//  能量圈
//
//  Created by 王斌 on 2018/4/18.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainCompleteView.h"
#import "ETTrainCompleteTableViewCell.h"

#import "ETTrainViewModel.h"

#import "ETTrainAudioManager.h"

#import "ETRewardView.h"
#import "ETBadgeView.h"

#import "ETReportPostVC.h"
#import "ETReportPostNavController.h"

static NSString * const pk_train_complete = @"pk_train_complete";
static NSString * const cancel_gray = @"cancel_gray";

@interface ETTrainCompleteView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *completeImageView;

@property (nonatomic, strong) UILabel *completeLabel;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UIButton *postButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) ETTrainViewModel *viewModel;

@end

@implementation ETTrainCompleteView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
        make.height.equalTo(@390);
    }];
    
    [self.completeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.topView);
        make.top.equalTo(@(kStatusBarHeight + 10));
    }];
    
    [self.completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.topView);
        make.top.equalTo(weakSelf.completeImageView.mas_bottom).with.offset(8);
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.completeLabel.mas_bottom).with.offset(30);
        make.left.right.bottom.equalTo(weakSelf.topView);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.postButton.mas_top).with.offset(-20);
    }];
    
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@60);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.height.equalTo(@60);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETTrainViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.topView];
    [self.topView addSubview:self.completeImageView];
    [self.topView addSubview:self.completeLabel];
    [self.topView addSubview:self.mainTableView];
    [self addSubview:self.remindLabel];
    [self addSubview:self.postButton];
    [self addSubview:self.closeButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [self.viewModel.trainFinishCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        NSLog(@"%@", responseObject);

        if ([responseObject[@"Status"] integerValue] == 200) {
            
            self.completeLabel.text = [NSString stringWithFormat:@"恭喜完成第%@次训练", responseObject[@"Data"][@"TrainFre"]];
            
            NSMutableArray *badgeModels = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"Data"][@"_Badge"]) {
                ETBadgeModel *model = [[ETBadgeModel alloc] initWithDictionary:dic error:nil];
                [badgeModels addObject:model];
            }
            NSMutableArray *praiseModels = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"Data"][@"_Praise"]) {
                ETPraiseModel *model = [[ETPraiseModel alloc] initWithDictionary:dic error:nil];
                [praiseModels addObject:model];
            }
            CGFloat duration = 0.f;
            if ([responseObject[@"Data"][@"Integral"] integerValue]) {
                duration = 2.0;
                
                NSString *content = [NSString stringWithFormat:@"%@积分", responseObject[@"Data"][@"Integral"]];
                NSString *extra = [NSString stringWithFormat:@"恭喜你，额外获得了%@积分", responseObject[@"Data"][@"RewardIntegral"]];
                if (badgeModels.count || praiseModels.count) {
                    if ([responseObject[@"Data"][@"RewardIntegral"] integerValue]) {
                        duration += 1;
                        [ETRewardView rewardViewWithContent:content extra:extra duration:duration audioType:ETAudioTypeGetBadge];
                    } else {
                        [ETRewardView rewardViewWithContent:content duration:duration audioType:ETAudioTypeGetBadge];
                    }
                } else {
                    if ([responseObject[@"Data"][@"RewardIntegral"] integerValue]) {
                        duration += 1;
                        [ETRewardView rewardViewWithContent:content extra:extra duration:duration audioType:ETAudioTypeReportPK];
                    } else {
                        [ETRewardView rewardViewWithContent:content duration:duration audioType:ETAudioTypeReportPK];
                    }
                }
                
                [NSTimer jk_scheduledTimerWithTimeInterval:duration block:^{
                    if (praiseModels.count) {
                        [ETBadgeView getPraiseViewWithModels:praiseModels];
                    }
                    if (badgeModels.count) {
                        [ETBadgeView getBadgeViewWithModels:badgeModels];
                    }
                } repeats:NO];
            }
            
            [self.mainTableView reloadData];
        }
    }];
    
    [self.viewModel.trainFinishCommand execute:nil];
    
    [[self.postButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id responseObject) {
        @strongify(self)
//        ETReportPostVC *postVC = [[ETReportPostVC alloc] init];
//        ETReportPostNavController *postNavVC = [[ETReportPostNavController alloc] initWithRootViewController:postVC];
//        [ETWindow.rootViewController presentViewController:postNavVC animated:YES completion:nil];
        
        [self.viewModel.trainFinishEndSubject sendNext:nil];
    }];
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.closeSubject sendNext:nil];
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

- (UIImageView *)completeImageView {
    if (!_completeImageView) {
        _completeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pk_train_complete]];
    }
    return _completeImageView;
}

- (UILabel *)completeLabel {
    if (!_completeLabel) {
        _completeLabel = [[UILabel alloc] init];
        _completeLabel.textAlignment = NSTextAlignmentCenter;
        _completeLabel.textColor = [UIColor jk_colorWithHexString:@"FE9A00"];
        _completeLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    }
    return _completeLabel;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_mainTableView registerNib:NibName(ETTrainCompleteTableViewCell) forCellReuseIdentifier:ClassName(ETTrainCompleteTableViewCell)];
    }
    return _mainTableView;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.numberOfLines = 2;
        _remindLabel.text = @"训练那么辛苦,\n发个能量贴说说现在的心情吧";
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.font = [UIFont systemFontOfSize:10];
        _remindLabel.textColor = ETTextColor_Fourth;
    }
    return _remindLabel;
}

- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [[UIButton alloc] init];
        [_postButton setTitle:@"去发布" forState:UIControlStateNormal];
        _postButton.backgroundColor = ETMarkYellowColor;
        _postButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        [_postButton setTitleColor:ETTextColor_Fifth forState:UIControlStateNormal];
        _postButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _postButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:cancel_gray] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (ETTrainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- UITableViewDelegate --

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -- UITableViewDataSource --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETTrainCompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETTrainCompleteTableViewCell) forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.leftLabel.text = self.viewModel.model.ProjectName;
        cell.rightLabel.text = [NSString stringWithFormat:@"%ld%@", (long)[self.viewModel.model.TargetNum integerValue], self.viewModel.model.ProjectUnit];
        cell.lineView.hidden = NO;
    } else if (indexPath.row == 1) {
        cell.leftLabel.text = @"时长";
        cell.rightLabel.text = [NSString stringWithFormat:@"%ld分钟", (long)([[ETTrainAudioManager sharedInstance] totalTrainPlayTime] / 60)];
        cell.lineView.hidden = NO;
    } else {
        cell.leftLabel.text = @"动作";
        cell.rightLabel.text = [NSString stringWithFormat:@"%@组", self.viewModel.model.GroupCount];
        cell.lineView.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
