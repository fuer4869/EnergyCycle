//
//  ETRestView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/20.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETRestView.h"

#import "ETCircleCountDownView.h"

#import "ETTrainViewModel.h"

@interface ETRestView () <ETCircleCountDownViewDelegate>

/** 底层视图 */
@property (nonatomic, strong) UIView *backgroundView;
/** 环型倒计时 */
@property (nonatomic, strong) ETCircleCountDownView *circleView;
/** 提示 */
@property (nonatomic, strong) UILabel *hint;
/** 项目详情 */
@property (nonatomic, strong) UIView *detailView;
/** 完成组数 */
@property (nonatomic, strong) UILabel *finishGroup;
/** 分割视图 */
@property (nonatomic, strong) UIView *partingView;
/** 下一个 */
@property (nonatomic, strong) UILabel *next;
/** 下一个的项目的名称和组数 */
@property (nonatomic, strong) UILabel *nextGroup;
/** 剩余 */
@property (nonatomic, strong) UILabel *last;
/** 剩余组数 */
@property (nonatomic, strong) UILabel *lastGroup;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) ETTrainViewModel *viewModel;

@end

@implementation ETRestView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.hint.mas_top).with.offset(-60);
        make.width.height.equalTo(@160);
    }];
    
    [self.hint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.detailView.mas_top).with.offset(-60);
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-60);
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.equalTo(@135);
    }];
    
    [self.finishGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.detailView);
        make.top.equalTo(weakSelf.detailView).with.offset(25);
    }];
    
    [self.partingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.detailView);
        make.top.equalTo(weakSelf.finishGroup.mas_bottom).with.offset(25);
        make.height.equalTo(@1);
    }];
    
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.partingView.mas_bottom).with.offset(18);
        make.right.equalTo(weakSelf.detailView.mas_centerX).with.offset(-25);
    }];
    
    [self.nextGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.next);
        make.left.equalTo(weakSelf.next.mas_right).with.offset(25);
    }];
    
    [self.last mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.next.mas_bottom);
        make.right.equalTo(weakSelf.detailView.mas_centerX).with.offset(-25);
    }];
    
    [self.lastGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.last);
        make.left.equalTo(weakSelf.last.mas_right).with.offset(25);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETTrainViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

#pragma mark -- private --

- (instancetype)initWithRestTime:(CGFloat)restTime {
    if (self = [super initWithFrame:ETScreenB]) {
        self.restTime = restTime;
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

- (void)et_setupViews {
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.circleView];
    [self.backgroundView addSubview:self.hint];
    [self.backgroundView addSubview:self.detailView];
    [self.backgroundView addSubview:self.backButton];
    [self.detailView addSubview:self.finishGroup];
    [self.detailView addSubview:self.partingView];
    [self.detailView addSubview:self.next];
    [self.detailView addSubview:self.nextGroup];
    [self.detailView addSubview:self.last];
    [self.detailView addSubview:self.lastGroup];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
//    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeAnimation)];
//    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark -- lazyLoad --

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = ETWhiteColor;
    }
    return _backgroundView;
}

- (ETCircleCountDownView *)circleView {
    if (!_circleView) {
        _circleView = [[ETCircleCountDownView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        _circleView.delegate = self;
        _circleView.totalTime = [self.viewModel.model.RestInterval integerValue];
    }
    return _circleView;
}

- (UILabel *)hint {
    if (!_hint) {
        _hint = [[UILabel alloc] init];
        _hint.font = [UIFont systemFontOfSize:16];
        _hint.textColor = ETTextColor_Fourth;
        _hint.text = @"轻触屏幕跳过休息";
    }
    return _hint;
}

- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
        _detailView.backgroundColor = [ETTextColor_Fifth colorWithAlphaComponent:0.1];
    }
    return _detailView;
}

- (UILabel *)finishGroup {
    if (!_finishGroup) {
        _finishGroup = [[UILabel alloc] init];
        _finishGroup.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _finishGroup.textColor = [UIColor blackColor];
//        _finishGroup.text = @"太棒了,已经完成第X组!";
        _finishGroup.text = [NSString stringWithFormat:@"太棒了,已经完成了第%@组!", self.viewModel.model.CurrGroupNo];
    }
    return _finishGroup;
}

- (UIView *)partingView {
    if (!_partingView) {
        _partingView = [[UIView alloc] init];
        _partingView.backgroundColor = [ETMinorBgColor colorWithAlphaComponent:0.1];
    }
    return _partingView;
}

- (UILabel *)next {
    if (!_next) {
        _next = [[UILabel alloc] init];
        _next.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _next.textColor = ETTextColor_Fourth;
        _next.text = @"接下来";
    }
    return _next;
}

- (UILabel *)nextGroup {
    if (!_nextGroup) {
        _nextGroup = [[UILabel alloc] init];
        _nextGroup.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _nextGroup.textColor = [UIColor blackColor];
//        _nextGroup.text = @"XXX 第X组";
        _nextGroup.text = [NSString stringWithFormat:@"%@ 第%ld组", self.viewModel.model.ProjectName, (long)([self.viewModel.model.CurrGroupNo integerValue] + 1)];
    }
    return _nextGroup;
}

- (UILabel *)last {
    if (!_last) {
        _last = [[UILabel alloc] init];
        _last.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _last.textColor = ETTextColor_Fourth;
        _last.text = @"剩余";
    }
    return _last;
}

- (UILabel *)lastGroup {
    if (!_lastGroup) {
        _lastGroup = [[UILabel alloc] init];
        _lastGroup.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        _lastGroup.textColor = [UIColor blackColor];
//        _lastGroup.text = @"X组";
        _lastGroup.text = [NSString stringWithFormat:@"%ld组", (long)([self.viewModel.model.GroupCount integerValue] - [self.viewModel.model.CurrGroupNo integerValue])];
    }
    return _lastGroup;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.adjustsImageWhenHighlighted = NO; // 取消高亮
        @weakify(self)
        [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self countDownTimeOut];
        }];
    }
    return _backButton;
}

- (ETTrainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- ETCircleCountDownViewDelegate --

- (void)countDownTimeOut {
    if ([self.delegate respondsToSelector:@selector(restOver)]) {
        [self.delegate restOver];
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
