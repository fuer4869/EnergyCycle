//
//  ETUpdatesAndActivitiesView.m
//  能量圈
//
//  Created by 王斌 on 2017/8/31.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETUpdatesAndActivitiesView.h"
#import "ETPopView.h"

#import "ETSysModel.h"

#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

@interface ETUpdatesAndActivitiesView () <UIScrollViewDelegate, ETPopViewDelegate>

/** 阴影层 */
@property (nonatomic, strong) UIButton *shadowView;
/** 滑动视图 */
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation ETUpdatesAndActivitiesView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).with.offset(-50);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.mainScrollView];
    [self addSubview:self.pageControl];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
    @weakify(self)
    
    [self.viewModel.versionCommand execute:nil];
//    [self.viewModel.sysDataCommand execute:nil];

    [self.viewModel.versionSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.sysDataCommand execute:nil];

    }];
    
    [self.viewModel.endSubject subscribeNext:^(id x) {
        @strongify(self)
        if (!self.viewModel.dataArray.count) {
            [self.viewModel.nothingSubject sendNext:nil];
            [self removeFromSuperview];
        } else {
            
            if (self.viewModel.dataArray.count > 1) {
                // 如果展示的提醒框是复数那么底部显示pagecontrol
                self.pageControl.numberOfPages = self.viewModel.dataArray.count;
            }
            
            self.mainScrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            self.mainScrollView.contentSize = CGSizeMake(ETScreenW * self.viewModel.dataArray.count, ETScreenH);
            CGRect rect = self.mainScrollView.bounds;
            rect.origin.x -= rect.size.width;
            for (ETSysModel *model in self.viewModel.dataArray) {
                rect.origin.x += rect.size.width;
                ETPopView *pop = [[ETPopView alloc] initWithFrame:rect];
                if ([model.NoticeType isEqualToString:@"1"]) {
                    [MobClick event:@"ETUpdateRemindShow"];
                    NSString *content = [NSString stringWithFormat:@"%@",[model.Notice_Content stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n" ]]; // 将请求得到的__NSCFString类型对象做处理让字符串可以识别换行符
                    [pop setupCustomizeSubviewsWithTitle:@"更新" Tip:content ImageURL:nil WidthScale:0.8 SureBtnTitle:@"更新" CancelBtnTitle:@"忽略"];
                    pop.shadowClose = NO;
                    pop.shadowView.backgroundColor = ETClearColor;
                    [[pop.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        @strongify(self)
                        NSLog(@"更新");
                        [MobClick event:@"ETUpdateRemindUpdateClick"];
                        NSString *scoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",@"1079791492"];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scoreUrl]];
                        [self removeFromSuperview];
                    }];
                    [[pop.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        @strongify(self)
                        NSLog(@"忽略");
                        [MobClick event:@"ETUpdateRemindIgnoreClick"];
                        [self removeFromSuperview];
                    }];
                }
                if ([model.NoticeType isEqualToString:@"2"]) {
//                    [pop setupCustomizeSubviewsWithTitle:@"新功能" Tip:@"" ImageURL:model.FilePath WidthScale:0.8 SureBtnTitle:@"知道了" CancelBtnTitle:@""];
                    [MobClick event:@"ETFunctionRemindShow"];
                    [pop setupCustomizeSubviewsWithImageURL:model.FilePath WidthScale:0.8 AspectRatio:1 / 0.75 SureBtnTitle:@"去看看" CancelBtnTitle:@"知道了"];
                    pop.shadowClose = NO;
                    pop.shadowView.backgroundColor = ETClearColor;
                    [[pop.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        @strongify(self)
                        NSLog(@"功能");
                        [MobClick event:@"ETFunctionRemindSeeClick"];
                        [self.viewModel.functionSubject sendNext:model];
                        [self removeFromSuperview];
                    }];
                    [[pop.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        @strongify(self)
                        NSLog(@"关闭");
                        [MobClick event:@"ETFunctionRemindKnowClick"];
                        [self.viewModel.nothingSubject sendNext:nil];
                        [self removeFromSuperview];
                    }];
                } else if ([model.NoticeType isEqualToString:@"3"]) {
//                    [pop setupCustomizeSubviewsWithTitle:@"活动" Tip:@"" ImageURL:model.FilePath WidthScale:0.8 SureBtnTitle:@"去看看" CancelBtnTitle:@"知道了"];
                    NSDictionary *dic = @{@"ActivityID" : model.Sys_NoticeID};
                    [MobClick event:@"ETActivityRemindShow" attributes:dic];
                    [pop setupCustomizeSubviewsWithImageURL:model.FilePath WidthScale:0.8 AspectRatio:1 / 0.75 SureBtnTitle:@"去看看" CancelBtnTitle:@"知道了"];
                    pop.shadowClose = NO;
                    pop.shadowView.backgroundColor = ETClearColor;
                    [[pop.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        @strongify(self)
                        NSLog(@"活动");
                        [MobClick event:@"ETActivityRemindSeeClick" attributes:dic];
                        [self.viewModel.activePageSubject sendNext:model.NoticeUrl];
                        [self removeFromSuperview];
                    }];
                    [[pop.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                        @strongify(self)
                        NSLog(@"关闭");
                        [MobClick event:@"ETActivityRemindKnowClick" attributes:dic];
                        [self.viewModel.nothingSubject sendNext:nil];
                        [self removeFromSuperview];
                    }];
                }
                [self.mainScrollView addSubview:pop];
            }

        }
    }];
    
}

#pragma mark -- lazyLoad --

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = YES;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [ETWhiteColor colorWithAlphaComponent:0.1];
        _pageControl.currentPageIndicatorTintColor = [ETWhiteColor colorWithAlphaComponent:0.3];
    }
    return _pageControl;
}

- (ETUpdatesAndActivitiesViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETUpdatesAndActivitiesViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate --

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"111");
//    self.pageControl.currentPage = self.mainScrollView.contentOffset.x / self.mainScrollView.jk_width;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.mainScrollView.contentOffset.x / self.mainScrollView.jk_width;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
