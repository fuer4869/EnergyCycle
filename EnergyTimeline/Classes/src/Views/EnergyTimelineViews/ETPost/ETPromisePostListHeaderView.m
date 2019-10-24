//
//  ETPromisePostListHeaderView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPromisePostListHeaderView.h"
#import "ETPromisePostListHeaderViewModel.h"
#import "ETPromisePostListCollectionViewCell.h"

@interface ETPromisePostListHeaderView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ETPromisePostListHeaderViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ETPromisePostListHeaderView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPromisePostListHeaderViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
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

- (ETPromisePostListHeaderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPromisePostListHeaderViewModel alloc] init];
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
        [_collectionView registerNib:NibName(ETPromisePostListCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETPromisePostListCollectionViewCell)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        _layout.minimumInteritemSpacing = 15;
        _layout.minimumLineSpacing = 15;
    }
    return _layout;
}

#pragma mark -- delegate and datasource --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPromisePostListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPromisePostListCollectionViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    cell.viewModel = nil;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPromisePostListCollectionCellViewModel *viewModel = self.viewModel.dataArray[indexPath.row];
    CGFloat totalWidth = 50;
    totalWidth += [viewModel.model.ProjectName jk_widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:50];
    totalWidth += [[NSString stringWithFormat:@"%@%@", viewModel.model.ReportNum, viewModel.model.ProjectUnit] jk_widthWithFont:[UIFont systemFontOfSize:16] constrainedToHeight:50];
    totalWidth += 52;
    return CGSizeMake(totalWidth, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
