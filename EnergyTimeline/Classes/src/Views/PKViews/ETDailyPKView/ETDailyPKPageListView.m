//
//  ETDailyPKPageListView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKPageListView.h"
#import "ETDailyPKPageViewModel.h"
#import "ETDailyPKPageListCollectionViewCell.h"

@interface ETDailyPKPageListView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *containerView;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) ETDailyPKPageViewModel *viewModel;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ETDailyPKPageListView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETDailyPKPageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.containerView];
    [self addSubview:self.shadowView];
    [self.shadowView addSubview:self.collectionView];
    [self.shadowView addSubview:self.leftButton];
    [self.shadowView addSubview:self.rightButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
}

- (void)updateConstraints {
//    WS(weakSelf)
//    CGFloat totalHeight = kStatusBarHeight + kTopBarHeight * (self.viewModel.titleArray.count / 4 + (self.viewModel.titleArray.count % 4 ? 1 : 0));
//    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.top.left.right.equalTo(weakSelf);
//     make.height.equalTo(@(totalHeight));
//    }];
//
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.top.equalTo(weakSelf.shadowView).with.offset(kStatusBarHeight);
//     make.left.equalTo(weakSelf.shadowView).with.offset(25);
//     make.right.equalTo(weakSelf.shadowView).with.offset(-25);
//     make.bottom.equalTo(weakSelf.shadowView);
//    }];
//
//    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.top.equalTo(weakSelf.shadowView).with.offset(kStatusBarHeight + 10);
//     make.left.equalTo(weakSelf.shadowView).with.offset(10);
//     make.right.equalTo(weakSelf.collectionView.mas_left).with.offset(10);
//    }];
//
//    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//     make.top.equalTo(weakSelf.shadowView).with.offset(kStatusBarHeight + 10);
//     make.left.equalTo(weakSelf.collectionView.mas_right).with.offset(-10);
//     make.right.equalTo(weakSelf.shadowView).with.offset(-10);
//    }];
    
    self.shadowView.frame = CGRectMake(0, 0, ETScreenW, kStatusBarHeight + kTopBarHeight);
    self.collectionView.frame = CGRectMake(44, kStatusBarHeight, ETScreenW - 88, kTopBarHeight);
    self.leftButton.frame = CGRectMake(10, 10 + kStatusBarHeight, 25, 25);
    self.rightButton.frame = CGRectMake(ETScreenW - 10 - 25, 10 + kStatusBarHeight, 25, 25);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGFloat totalWidth = 15;
                         CGFloat heightCount = 1;
                         for (NSString *title in self.viewModel.titleArray) {
                             totalWidth += [title jk_widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:kTopBarHeight] + 15;
                             if (totalWidth >= ETScreenW - 88) {
                                 heightCount ++;
                                 totalWidth = [title jk_widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:kTopBarHeight] + 30;
                             }
                         }
                         
//        CGFloat totalHeight = kStatusBarHeight + kTopBarHeight * (self.viewModel.titleArray.count / 4 + (self.viewModel.titleArray.count % 4 ? 1 : 0));
        CGFloat totalHeight = kStatusBarHeight + kTopBarHeight * heightCount;
        self.shadowView.frame = CGRectMake(0, 0, ETScreenW, totalHeight);
        self.collectionView.frame = CGRectMake(44, kStatusBarHeight, ETScreenW - 88, totalHeight - kStatusBarHeight);
    }];
    
    [super updateConstraints];
}

- (void)leftClickEvent {
    [self.viewModel.popSubject sendNext:nil];
}

- (void)removeEvent {
    [self.viewModel.removePageViewSubject sendNext:nil];
}

#pragma mark -- lazyLoad --

- (UIButton *)containerView {
    if (!_containerView) {
        _containerView = [[UIButton alloc] init];
        _containerView.frame = ETScreenB;
        [_containerView addTarget:self action:@selector(removeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _containerView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.6];
    }
    return _shadowView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETClearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETDailyPKPageListCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETDailyPKPageListCollectionViewCell)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 15;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setImage:[UIImage imageNamed:ETWhiteBack] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setImage:[UIImage imageNamed:@"recover_white"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(removeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark -- delegate -- 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETDailyPKPageListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETDailyPKPageListCollectionViewCell) forIndexPath:indexPath];
    cell.projectNameLabel.text = self.viewModel.titleArray[indexPath.row];
    if (indexPath.row == self.viewModel.currentIndex) {
        cell.statusView.hidden = NO;
    } else {
        cell.statusView.hidden = YES;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [self.viewModel.titleArray[indexPath.row] jk_widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:kTopBarHeight];
    return CGSizeMake(width, kTopBarHeight);
//    return CGSizeMake((self.jk_width - 2 * 25) / 4, kTopBarHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.currentIndex = indexPath.row;
    [self.viewModel.pageViewCellClickSubject sendNext:indexPath];
    [self.collectionView reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
