//
//  ETProjectTypeView.m
//  能量圈
//
//  Created by 王斌 on 2018/1/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETProjectTypeView.h"
#import "ETSearchProjectViewModel.h"
#import "ETProjectCollectionViewCell.h"

@interface ETProjectTypeView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) ETSearchProjectViewModel *viewModel;

@end

@implementation ETProjectTypeView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETSearchProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainCollectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    [[self.viewModel.refreshEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
        @strongify(self)
        if (self.typeIndex == [number integerValue]) {
            [self.mainCollectionView reloadData];
        }
    }];
    
}

#pragma mark -- lazyLoad --

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
//        _mainCollectionView.allowsMultipleSelection = YES; // 多选
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        [_mainCollectionView registerNib:NibName(ETProjectCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETProjectCollectionViewCell)];
        
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 15;
        _layout.minimumInteritemSpacing = 15;
        _layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        CGFloat itemWidth = (ETScreenW - 60) / 3;
        _layout.itemSize = CGSizeMake(itemWidth, (itemWidth * 8) / 7);
    }
    return _layout;
}

- (ETSearchProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSearchProjectViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- collectionView delegate and datasource --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.viewModel.dataArray.count;
    return [self.viewModel.dataArray[self.typeIndex] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETProjectCollectionViewCell) forIndexPath:indexPath];
    //    ETPKProjectModel *model = self.viewModel.dataArray[indexPath.row];
    ETPKProjectModel *model = self.viewModel.dataArray[self.typeIndex][indexPath.row];
//    for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
//        if ([selectModel.ProjectID isEqualToString:model.ProjectID]) {
//            [cell setSelected:YES];
//            [self.mainCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//        }
//    }
    for (NSUInteger i = 0; i < self.viewModel.selectArray.count; i ++) {
        ETPKProjectModel *selectModel = self.viewModel.selectArray[i];
        if ([selectModel.ProjectID isEqualToString:model.ProjectID]) {
            [cell setSelected:YES];
            [self.mainCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }

    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.isPromise) {
        [self.viewModel.promiseSetProjectSubject sendNext:self.viewModel.dataArray[self.typeIndex][indexPath.row]];
    } else {
//        [self.viewModel.selectArray addObject:self.viewModel.dataArray[self.typeIndex][indexPath.row]];
        [self.viewModel.reportPKSubject sendNext:self.viewModel.dataArray[self.typeIndex][indexPath.row]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%@", self.viewModel.dataArray[indexPath.row]);
    ETPKProjectModel *model = self.viewModel.dataArray[self.typeIndex][indexPath.row];
    for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
        if ([model.ProjectID isEqualToString:selectModel.ProjectID]) {
            [self.viewModel.selectArray removeObject:selectModel];
            return;
        }
    }
    //    [self.viewModel.selectArray removeObject:self.viewModel.dataArray[indexPath.row]];
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
