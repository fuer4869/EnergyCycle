//
//  ETProjectView.m
//  能量圈
//
//  Created by 王斌 on 2017/8/2.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETProjectView.h"
#import "ETProjectViewModel.h"
#import "ETProjectCollectionViewCell.h"

@interface ETProjectView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) ETProjectViewModel *viewModel;

@end

@implementation ETProjectView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainCollectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainCollectionView reloadData];
    }];
}

#pragma mark -- lazyLoad --

- (ETProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETProjectViewModel alloc] init];
    }
    return _viewModel;
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.allowsMultipleSelection = YES;
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

#pragma mark -- delegate and dataSource --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETProjectCollectionViewCell) forIndexPath:indexPath];
    ETPKProjectModel *model = self.viewModel.dataArray[indexPath.row];
    for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
        if ([selectModel.ProjectID isEqualToString:model.ProjectID]) {
            [cell setSelected:YES];
            [self.mainCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.selectArray addObject:self.viewModel.dataArray[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKProjectModel *model = self.viewModel.dataArray[indexPath.row];
    for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
        if ([model.ProjectID isEqualToString:selectModel.ProjectID]) {
            [self.viewModel.selectArray removeObject:selectModel];
            return;
        }
    }
//    [self.viewModel.selectArray removeObject:self.viewModel.dataArray[indexPath.row]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
