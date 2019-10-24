//
//  ETRadioView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/6.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETRadioView.h"
#import "ETRadioViewModel.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "ETRadioCollectionViewCell.h"

#import "ETRadioManager.h"
#import "NSString+Time.h"

//#import "ETRadioModel.h"

static NSString * const radio_more = @"radio_more";
static NSString * const radio_last = @"radio_last";
static NSString * const radio_play = @"radio_play";
static NSString * const radio_pause = @"radio_pause";
static NSString * const radio_next = @"radio_next";
static NSString * const radio_list = @"radio_list";
static NSString * const radio_timePlay = @"radio_timePlay";
static NSString * const radio_timeStop = @"radio_timeStop";

@interface ETRadioView () <NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic, strong) UILabel *radioNameLabel;

@property (nonatomic, strong) ETRadioViewModel *viewModel;

@property (nonatomic, strong) UIView *operateView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILabel *listenLabel;

@property (nonatomic, strong) UILabel *listenTime;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UIButton *lastButton;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIButton *listButton;

@property (nonatomic, strong) UIView *moreView;

@property (nonatomic, strong) UIButton *timePlay;

@property (nonatomic, strong) UIButton *timeStop;

@property (nonatomic, strong) UIButton *moreCancelButton;

@property (nonatomic, strong) UIView *radioListView;

@property (nonatomic, strong) UILabel *radioListLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UIButton *listCancelButton;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation ETRadioView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETRadioViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.top.equalTo(weakSelf).with.offset(15 + kStatusBarHeight);
    }];
    
    [self.pageFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(70 + kStatusBarHeight);
        make.height.equalTo(weakSelf.mas_width).multipliedBy(0.85);
    }];
    
    [self.radioNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pageFlowView.mas_bottom).with.offset(IsiPhoneX ? 67.f : 18.f);
        make.centerX.equalTo(weakSelf);
    }];
    
    // operateView
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.radioNameLabel.mas_bottom).with.offset(IsiPhoneX ? 30.f : 0.f);
        make.left.right.bottom.equalTo(weakSelf);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.operateView).with.offset(30);
        make.right.equalTo(weakSelf.operateView).with.offset(-30);
        make.top.equalTo(weakSelf.operateView).with.offset(20);
    }];
    
    [self.listenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.operateView).with.offset(30);
        make.top.equalTo(weakSelf.progressView.mas_bottom).with.offset(10);
    }];
    
    [self.listenTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.operateView).with.offset(-30);
        make.top.equalTo(weakSelf.progressView.mas_bottom).with.offset(10);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lastButton.mas_left).with.offset(-20);
        make.centerY.equalTo(weakSelf.lastButton);
    }];
    
    [self.lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.playButton.mas_left).with.offset(-20);
        make.centerY.equalTo(weakSelf.playButton);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.operateView.mas_bottom).with.offset(IsiPhoneX ? -60.f : -16.f);
        make.centerX.equalTo(weakSelf.operateView);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.playButton.mas_right).with.offset(20);
        make.centerY.equalTo(weakSelf.playButton);
    }];
    
    [self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nextButton.mas_right).with.offset(20);
        make.centerY.equalTo(weakSelf.nextButton);
    }];
    
    // moreView
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.radioNameLabel.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf);
    }];
    
    [self.timePlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.moreView).with.offset(42);
        make.bottom.equalTo(weakSelf.moreCancelButton.mas_top).with.offset(-40);
    }];
    
    [self.timeStop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.moreView).with.offset(-42);
        make.bottom.equalTo(weakSelf.moreCancelButton.mas_top).with.offset(-40);
    }];
    
    [self.moreCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.moreView);
        make.height.equalTo(@50);
    }];
    
    // radioListView
    [self.radioListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.radioNameLabel.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf);
    }];
    
    [self.radioListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.radioListView);
        make.left.equalTo(weakSelf.radioListView).with.offset(25);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.radioListView);
        make.bottom.equalTo(weakSelf.listCancelButton.mas_top);
        make.top.equalTo(weakSelf.radioListLabel.mas_bottom);
    }];
    
    [self.listCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.radioListView);
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.dismissButton];
    [self addSubview:self.pageFlowView];
    [self addSubview:self.radioNameLabel];
    [self addSubview:self.operateView];
    [self addSubview:self.moreView];
    [self addSubview:self.radioListView];
    
    [self.operateView addSubview:self.progressView];
    [self.operateView addSubview:self.listenLabel];
    [self.operateView addSubview:self.listenTime];
    [self.operateView addSubview:self.moreButton];
    [self.operateView addSubview:self.lastButton];
    [self.operateView addSubview:self.playButton];
    [self.operateView addSubview:self.nextButton];
    [self.operateView addSubview:self.listButton];
    
    [self.moreView addSubview:self.timePlay];
    [self.moreView addSubview:self.timeStop];
    [self.moreView addSubview:self.moreCancelButton];
    
    [self.radioListView addSubview:self.radioListLabel];
    [self.radioListView addSubview:self.collectionView];
    [self.radioListView addSubview:self.listCancelButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
//    RAC(self.progressView, progress) = [[[[ETRadioManager sharedInstance] playback] currentItem] timePlayed];
    
    @weakify(self)
    [self.viewModel.radioDataCommand execute:nil];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.pageFlowView reloadData];
        if ([[ETRadioManager sharedInstance] playing]) {
            [self.pageFlowView scrollToPage:self.viewModel.currentIndex];
            self.link.paused = NO;
        }
        ETRadioModel *model = self.viewModel.radioArray[self.pageFlowView.currentPageIndex];
        self.radioNameLabel.text = model.RadioName;
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.Radio_Bg_Dim]];
    }];
    
}

- (void)refreshUI {
    self.listenTime.text = [NSString convertMinAndSecWithTime:[[ETRadioManager sharedInstance] totalPlayTime] + [[ETRadioManager sharedInstance] playTime]];
    CGFloat playTime = [[ETRadioManager sharedInstance] playTime] + [[ETRadioManager sharedInstance] totalPlayTime];
    if ([[ETRadioManager sharedInstance] isClock]) {
        self.progressView.progress = (CGFloat)([[ETRadioManager sharedInstance] clockTimeDuration] - playTime) / (CGFloat)[[ETRadioManager sharedInstance] clockTimeDuration];
    } else {
//        CGFloat duration = playTime == duration ? playTime + 60 : duration;
        self.progressView.progress = playTime / (CGFloat)[[ETRadioManager sharedInstance] totalTime];
    }
}

#pragma mark -- lazyLoad --

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.frame = ETScreenB;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.layer.masksToBounds = YES;
    }
    return _bgImageView;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] init];
        [_dismissButton setImage:[UIImage imageNamed:ETDownArrow_White] forState:UIControlStateNormal];
        [[_dismissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self.link invalidate];
            [self.viewModel.dismissSubject sendNext:nil];
        }];
    }
    return _dismissButton;
}

- (NewPagedFlowView *)pageFlowView {
    if (!_pageFlowView) {
        _pageFlowView = [[NewPagedFlowView alloc] init];
        _pageFlowView.scrollView.pagingEnabled = YES;
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0;
        _pageFlowView.topBottomMargin = 40;
        _pageFlowView.leftRightMargin = 40;
        _pageFlowView.orginPageCount = self.viewModel.radioArray.count;
        _pageFlowView.isOpenAutoScroll = NO;
    }
    return _pageFlowView;
}

- (UILabel *)radioNameLabel {
    if (!_radioNameLabel) {
        _radioNameLabel = [[UILabel alloc] init];
        _radioNameLabel.textColor = [UIColor colorWithHexString:@"313131"];
        _radioNameLabel.font = [UIFont systemFontOfSize:36];
    }
    return _radioNameLabel;
}

/** 操作视图 */
- (UIView *)operateView {
    if (!_operateView) {
        _operateView = [[UIView alloc] init];
    }
    return _operateView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progress = 1;
        _progressView.trackTintColor = [ETWhiteColor colorWithAlphaComponent:0.8];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"99e4ff"];
    }
    return _progressView;
}

- (UILabel *)listenLabel {
    if (!_listenLabel) {
        _listenLabel = [[UILabel alloc] init];
        _listenLabel.text = @"收听时长";
        _listenLabel.textColor = ETWhiteColor;
        _listenLabel.font = [UIFont systemFontOfSize:12];
    }
    return _listenLabel;
}

- (UILabel *)listenTime {
    if (!_listenTime) {
        _listenTime = [[UILabel alloc] init];
        _listenTime.text = @"00:00";
        _listenTime.textColor = ETWhiteColor;
        _listenTime.font = [UIFont systemFontOfSize:12];
    }
    return _listenTime;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:radio_more] forState:UIControlStateNormal];
        @weakify(self)
        [[_moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.operateView.hidden = YES;
            self.moreView.hidden = NO;
        }];
    }
    return _moreButton;
}

- (UIButton *)lastButton {
    if (!_lastButton) {
        _lastButton = [[UIButton alloc] init];
        [_lastButton setImage:[UIImage imageNamed:radio_last] forState:UIControlStateNormal];
        @weakify(self)
        [[_lastButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            NSInteger lastIndex = self.pageFlowView.currentPageIndex ? self.pageFlowView.currentPageIndex - 1 : self.pageFlowView.orginPageCount - 1;
            [self.pageFlowView scrollToLastPage];
            if ([[ETRadioManager sharedInstance] playing]) {
                [self.viewModel.replacePlaySubject sendNext:@(lastIndex)];
            }
        }];
    }
    return _lastButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:[[ETRadioManager sharedInstance] playing] ? radio_pause : radio_play] forState:UIControlStateNormal];
        @weakify(self)
        [[_playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (![[ETRadioManager sharedInstance] playing]) {
                [_playButton setImage:[UIImage imageNamed:radio_pause] forState:UIControlStateNormal];
                if (self.viewModel.currentIndex == self.pageFlowView.currentPageIndex) {
                    [[ETRadioManager sharedInstance] playUrlWithString:[self.viewModel.radioArray[self.pageFlowView.currentPageIndex] RadioUrl]];
                } else {
                    [self.viewModel.replacePlaySubject sendNext:@(self.pageFlowView.currentPageIndex)];
                }
                self.link.paused = NO;
            } else {
                [_playButton setImage:[UIImage imageNamed:radio_play] forState:UIControlStateNormal];
                [[ETRadioManager sharedInstance] pause];
                self.link.paused = YES;
            }
        }];
    }
    return _playButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton setImage:[UIImage imageNamed:radio_next] forState:UIControlStateNormal];
        @weakify(self)
        [[_nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            NSInteger nextIndex = self.pageFlowView.currentPageIndex == self.pageFlowView.orginPageCount - 1 ? 0 : self.pageFlowView.currentPageIndex + 1;
            [self.pageFlowView scrollToNextPage];
            if ([[ETRadioManager sharedInstance] playing]) {
                [self.viewModel.replacePlaySubject sendNext:@(nextIndex)];
            }
        }];
    }
    return _nextButton;
}

- (UIButton *)listButton {
    if (!_listButton) {
        _listButton = [[UIButton alloc] init];
        [_listButton setImage:[UIImage imageNamed:radio_list] forState:UIControlStateNormal];
        @weakify(self)
        [[_listButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.operateView.hidden = YES;
            self.radioListView.hidden = NO;
        }];
    }
    return _listButton;
}

/** 更多视图 */
- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        _moreView.hidden = YES;
    }
    return _moreView;
}

- (UIButton *)timePlay {
    if (!_timePlay) {
        _timePlay = [[UIButton alloc] init];
        [_timePlay.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_timePlay setTitle:@"定时播放" forState:UIControlStateNormal];
        [_timePlay setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        [_timePlay setImage:[UIImage imageNamed:radio_timePlay] forState:UIControlStateNormal];
        @weakify(self)
        [[_timePlay rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.radioPlayVCSubject sendNext:nil];
        }];
    }
    return _timePlay;
}

- (UIButton *)timeStop {
    if (!_timeStop) {
        _timeStop = [[UIButton alloc] init];
        [_timeStop.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeStop setTitle:@"定时停止" forState:UIControlStateNormal];
        [_timeStop setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        [_timeStop setImage:[UIImage imageNamed:radio_timeStop] forState:UIControlStateNormal];
        @weakify(self)
        [[_timeStop rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.radioDurationTimeVCSubject sendNext:nil];
        }];
    }
    return _timeStop;
}

- (UIButton *)moreCancelButton {
    if (!_moreCancelButton) {
        _moreCancelButton = [[UIButton alloc] init];
        [_moreCancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_moreCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_moreCancelButton setTitleColor:[UIColor colorWithHexString:@"99e4ff"] forState:UIControlStateNormal];
//        [_moreCancelButton jk_addTopBorderWithColor:[UIColor colorWithHexString:@"99e4ff"] width:10];
        [_moreCancelButton jk_addTopBorderWithColor:[UIColor colorWithHexString:@"99e4ff"] width:1 excludePoint:ETScreenW edgeType:JKExcludeStartPoint];
        @weakify(self)
        [[_moreCancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.moreView.hidden = YES;
            self.operateView.hidden = NO;
        }];
    }
    return _moreCancelButton;
}

/** 列表视图 */
- (UIView *)radioListView {
    if (!_radioListView) {
        _radioListView = [[UIView alloc] init];
        _radioListView.hidden = YES;
    }
    return _radioListView;
}

- (UILabel *)radioListLabel {
    if (!_radioListLabel) {
        _radioListLabel = [[UILabel alloc] init];
        _radioListLabel.text = @"电台列表";
        _radioListLabel.font = [UIFont systemFontOfSize:12];
        _radioListLabel.textColor = [UIColor colorWithHexString:@"99e4ff"];
    }
    return _radioListLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 100) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETClearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETRadioCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETRadioCollectionViewCell)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UIButton *)listCancelButton {
    if (!_listCancelButton) {
        _listCancelButton = [[UIButton alloc] init];
        [_listCancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_listCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_listCancelButton setTitleColor:[UIColor colorWithHexString:@"99e4ff"] forState:UIControlStateNormal];
        [_listCancelButton jk_addTopBorderWithColor:[UIColor colorWithHexString:@"99e4ff"] width:1 excludePoint:ETScreenW edgeType:JKExcludeStartPoint];
        @weakify(self)
        [[_listCancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            self.radioListView.hidden = YES;
            self.operateView.hidden = NO;
        }];
    }
    return _listCancelButton;
}

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshUI)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}

#pragma mark -- NewPageDlowDelegate AND DataScoure --

- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.viewModel.radioArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    PGIndexBannerSubiew *radio = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!radio) {
        radio = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, ETScreenW * 0.85, ETScreenW * 0.85)];
        radio.layer.cornerRadius = 10;
        radio.layer.masksToBounds = YES;
    }
    [radio.mainImageView sd_setImageWithURL:[NSURL URLWithString:[self.viewModel.radioArray[index] Radio_Bg]]];
    return radio;
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(ETScreenW * 0.85, ETScreenW * 0.85);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    ETRadioModel *model = self.viewModel.radioArray[pageNumber];
    self.radioNameLabel.text = model.RadioName;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.Radio_Bg_Dim]];
}

- (void)didEndDeceleratingWithPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    if ([[ETRadioManager sharedInstance] playing]) {
        [self.viewModel.replacePlaySubject sendNext:@(pageNumber)];
    }
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"%ld", (long)subIndex);
}

#pragma mark -- collectionViewDelegate and datasource --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.radioArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETRadioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETRadioCollectionViewCell) forIndexPath:indexPath];
    cell.model = self.viewModel.radioArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.pageFlowView scrollToPage:indexPath.row];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
