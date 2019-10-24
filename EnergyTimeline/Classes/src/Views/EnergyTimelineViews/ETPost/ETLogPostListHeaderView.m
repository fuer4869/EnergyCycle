//
//  ETLogPostListHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/11/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLogPostListHeaderView.h"
#import "ETLogPostListHeaderViewModel.h"
#import "ETLogPostListCollectionViewCell.h"

@interface ETLogPostListHeaderView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ETLogPostListHeaderViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ETLogPostListHeaderView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETLogPostListHeaderViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(10);
        make.top.equalTo(weakSelf).with.offset(10);
        make.height.equalTo(@10);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.collectionView reloadData];
    }];
}

#pragma mark -- lazyLoad --

- (ETLogPostListHeaderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETLogPostListHeaderViewModel alloc] init];
    }
    return _viewModel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETMainBgColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETLogPostListCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETLogPostListCollectionViewCell)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 10;
        _layout.minimumInteritemSpacing = 10;
    }
    return _layout;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"高手推荐";
        _titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor colorWithHexString:@"3C3A55"];
        _titleLabel.textColor = ETTextColor_Second;
    }
    return _titleLabel;
}

#pragma mark -- delegate and datasource --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETLogPostListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETLogPostListCollectionViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
    [self.viewModel.cellClickSubject sendNext:[self.viewModel.dataArray[indexPath.row] model]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
