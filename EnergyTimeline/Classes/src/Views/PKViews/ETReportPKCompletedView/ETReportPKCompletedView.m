//
//  ETReportPKCompletedView.m
//  能量圈
//
//  Created by 王斌 on 2017/10/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKCompletedView.h"
#import "ETReportPKCompletedViewModel.h"
#import "ETReportPKCompletedCollectionViewCell.h"

#import "ETPageCardFlowLayout.h"

#import "UIColor+GradientColors.h"

#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

static NSString * const reportCompleted = @"pk_report_completed";

static NSInteger const maxSections = 50;

@interface ETReportPKCompletedView () <UICollectionViewDataSource, UICollectionViewDelegate, ETPageCardFlowLayoutDelegate>

@property (nonatomic, strong) ETReportPKCompletedViewModel *viewModel;

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) ETPageCardFlowLayout *layout;

@property (nonatomic, strong) UIButton *completedButton;

@property (nonatomic, strong) UIButton *reportPostButton;

//@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation ETReportPKCompletedView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETReportPKCompletedViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(50);
        make.centerX.equalTo(weakSelf);
    }];
    
    [self.completedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-10);
        make.top.equalTo(weakSelf).with.offset(25);
        make.height.equalTo(40);
        make.width.equalTo(60);
    }];
    
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.reportPostButton.mas_top).with.offset(-10);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@250);
    }];
    
    [self.reportPostButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).with.offset(-30);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

- (void)et_setupViews {
    [self addSubview:self.topImageView];
    [self addSubview:self.completedButton];
    [self addSubview:self.mainCollectionView];
    [self addSubview:self.reportPostButton];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self)
    [[self.viewModel.refreshEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.mainCollectionView reloadData];
        [self scrollToItemAtIndexPath:0 andSection:(maxSections / 2 - 1) withAnimated:NO];
    }];
}

#pragma mark -- lazyLoad --

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:reportCompleted];
    }
    return _topImageView;
}

- (UIButton *)completedButton {
    if (!_completedButton) {
        _completedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _completedButton.adjustsImageWhenHighlighted = NO;
        [_completedButton setTitle:@"完成" forState:UIControlStateNormal];
        _completedButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_completedButton setTitleColor:ETTextColor_First forState:UIControlStateNormal];
        @weakify(self)
        [[_completedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.completedSubject sendNext:nil];
        }];
    }
    return _completedButton;
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = ETClearColor;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [_mainCollectionView registerNib:NibName(ETReportPKCompletedCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETReportPKCompletedCollectionViewCell)];
    }
    return _mainCollectionView;
}

- (ETPageCardFlowLayout *)layout {
    if (!_layout) {
        _layout = [[ETPageCardFlowLayout alloc] init];
        _layout.delegate = self;
        _layout.minimumLineSpacing = 20;
        _layout.minimumInteritemSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _layout.itemSize = CGSizeMake(ETScreenW - 80, (ETScreenW - 80) * 0.85);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UIButton *)reportPostButton {
    if (!_reportPostButton) {
        _reportPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportPostButton.layer.cornerRadius = 25;
        _reportPostButton.backgroundColor = [UIColor colorWithETGradientStyle:ETGradientStyleTopLeftToBottomRight withFrame:CGRectMake(0, 0, ETScreenW, 74) andColors:@[[UIColor colorWithHexString:@"FF5C90"], [UIColor colorWithHexString:@"FF8C6E"]]];
        [_reportPostButton setTitle:@"谈谈现在的感受吧..." forState:UIControlStateNormal];
        _reportPostButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _reportPostButton.titleLabel.textColor = ETWhiteColor;
        @weakify(self)
        [[_reportPostButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.reportPostSubject sendNext:nil];
        }];
    }
    return _reportPostButton;
}

#pragma mark -- delegate --

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return maxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.pkDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETReportPKCompletedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETReportPKCompletedCollectionViewCell) forIndexPath:indexPath];
    cell.model = self.viewModel.pkDataArray[indexPath.row];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(ETScreenW - 80, (ETScreenW - 80) * 0.85);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 20, 0, 20);
    CGFloat width = ((collectionView.frame.size.width - self.layout.itemSize.width)-(self.layout.minimumLineSpacing * 2))/2;
    
    if (section == 0) {
        return UIEdgeInsetsMake(0, width + self.layout.minimumLineSpacing, 0, 0);//分别为上、左、下、右
    }
    else if(section == (maxSections - 1)){
        return UIEdgeInsetsMake(0, 0, 0, width + self.layout.minimumLineSpacing);//分别为上、左、下、右
    }
    else{
        return UIEdgeInsetsMake(0, self.layout.minimumLineSpacing, 0, 0);//分别为上、左、下、右
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

- (void)scrollToItemAtIndexPath:(NSInteger)indexPath andSection:(NSInteger)section withAnimated:(BOOL)animated{
    
    UICollectionViewLayoutAttributes *attr = [self.mainCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath inSection:section]];
    [self.mainCollectionView scrollToItemAtIndexPath:attr.indexPath
                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:animated];
    
    self.layout.previousOffsetX = (indexPath + section * self.viewModel.pkDataArray.count) * (self.layout.itemSize.width + self.layout.minimumLineSpacing);
}

#pragma mark -- ETPageCardDlowLayoutDelegate --

- (void)scrollToPageIndex:(NSInteger)index {
    
}

//- (NewPagedFlowView *)pageFlowView {
//    if (!_pageFlowView) {
//        _pageFlowView = [[NewPagedFlowView alloc] init];
//
//    }
//    return _pageFlowView;
//}

#pragma mark -- NewPageFlowViewDelegate And NewPageFlowViewDataSource --

//- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
//    return 5;
//}
//
//- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
//    PGIndexBannerSubiew *subview = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
//    if (!subview) {
//        subview = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, ETScreenW - 80, 200)];
//        []
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
