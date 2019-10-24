//
//  ETPKProjectPageListView.m
//  能量圈
//
//  Created by 王斌 on 2018/1/16.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectPageListView.h"
#import "ETPKProjectPageViewModel.h"
#import "ETPKProjectPageListCollectionViewCell.h"

#import "ETPKProjectTypeModel.h"
#import "ETDailyPKProjectRankListModel.h"

static NSString * const headerViewIdentifier = @"headerView";

@interface ETPKProjectPageListCollectionViewFlowLayout : UICollectionViewFlowLayout

@end

@implementation ETPKProjectPageListCollectionViewFlowLayout

// cell左侧对齐布局
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for(int i =1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i -1];
        //        NSLog(@"%ld  %ld", currentLayoutAttributes.indexPath.section, currentLayoutAttributes.indexPath.row);
        if (currentLayoutAttributes.indexPath.section == prevLayoutAttributes.indexPath.section && currentLayoutAttributes.frame.origin.x != 0
            ) {
            //设置最大间距，可根据需要改
            NSInteger maximumSpacing = 15;
            //前一个cell的最右边
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
            //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
            if( origin + maximumSpacing + currentLayoutAttributes.frame.size.width <=self.collectionViewContentSize.width-15) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
            else {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = maximumSpacing;
                frame.origin.y =CGRectGetMaxY(prevLayoutAttributes.frame) + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
    return attributes;
}

@end


@interface ETPKProjectPageListView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ETPKProjectPageListCollectionViewFlowLayout *layout;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) ETPKProjectPageViewModel *viewModel;

@end

@implementation ETPKProjectPageListView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKProjectPageViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.collectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- lazyLoad --

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETMinorBgColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETPKProjectPageListCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETPKProjectPageListCollectionViewCell)];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    }
    return _collectionView;
}

- (ETPKProjectPageListCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[ETPKProjectPageListCollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 15;
        _layout.minimumInteritemSpacing = 15;
        _layout.headerReferenceSize = CGSizeMake(ETScreenW, 50);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (ETPKProjectPageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectPageViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- UICollectionViewDelegate --

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.projectTypeArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.projectTypeDataArray[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        if (!reusableView.subviews.count) {
//            UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 50)];
//            headerSectionView.backgroundColor = ETMinorBgColor;
            UIView *leftView = [[UIView alloc] init];
            leftView.backgroundColor = ETMarkYellowColor;
            [reusableView addSubview:leftView];
            [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(reusableView).with.offset(18);
                make.bottom.equalTo(reusableView);
                make.width.equalTo(@2);
                make.height.equalTo(@12);
            }];
            UILabel *rightLabel = [[UILabel alloc] init];
            ETPKProjectTypeModel *model = self.viewModel.projectTypeArray[indexPath.section];
            rightLabel.text = model.ProjectTypeName;
            rightLabel.textColor = ETTextColor_First;
            [rightLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
            [reusableView addSubview:rightLabel];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftView.mas_right).with.offset(6);
                make.centerY.equalTo(leftView);
            }];
        } else {
            for (UILabel *label in reusableView.subviews) {
                if ([label isKindOfClass:[UILabel class]]) {
                    ETPKProjectTypeModel *model = self.viewModel.projectTypeArray[indexPath.section];
                    //                label.text = model.ProjectTypeName;
                    [label setText:model.ProjectTypeName];
                }
            }
        }
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectPageListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPKProjectPageListCollectionViewCell) forIndexPath:indexPath];
    cell.projectNameLabel.text = [self.viewModel.projectTypeDataArray[indexPath.section][indexPath.row] ProjectName];
    cell.layer.cornerRadius = 8;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETDailyPKProjectRankListModel *model = self.viewModel.projectTypeDataArray[indexPath.section][indexPath.row];
    CGFloat width = [model.ProjectName jk_widthWithFont:[UIFont systemFontOfSize:15] constrainedToHeight:35] + 30;
    return CGSizeMake(width, 35);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectPageListCollectionViewCell *cell = (ETPKProjectPageListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [UIView animateWithDuration:0.2 animations:^{
            cell.alpha = 0.3;
        } completion:^(BOOL finished) {
            ETDailyPKProjectRankListModel *model = self.viewModel.projectTypeDataArray[indexPath.section][indexPath.row];
            for (NSString *title in self.viewModel.titleArray) {
                if ([model.ProjectName isEqualToString:title]) {
                    [self.viewModel.projectListCellClickSubject sendNext:[NSNumber numberWithInteger:[self.viewModel.titleArray indexOfObject:title]]];
                    return;
                }
            }
        }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
