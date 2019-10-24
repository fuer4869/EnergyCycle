//
//  ETMineBadgeView.m
//  能量圈
//
//  Created by 王斌 on 2017/11/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineBadgeView.h"
#import "ETMineBadgeViewModel.h"

#import "ETMineBadgeCollectionViewCell.h"

@interface ETMineBadgeView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) ETMineBadgeViewModel *viewModel;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ETMineBadgeView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETMineBadgeViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

- (void)et_setupViews {
    [self addSubview:self.mainCollectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


- (void)et_bindViewModel {
    @weakify(self)
    
    [[self.viewModel.refreshEndSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        switch (self.badgeType) {
            case 1: {
                self.dataArray = self.viewModel.pkArray;
            }
                break;
            case 2: {
                self.dataArray = self.viewModel.earlyArray;
            }
                break;
            case 3: {
                self.dataArray = self.viewModel.checkInArray;
            }
                break;
            default:
                break;
        }
        [self.mainCollectionView reloadData];
    }];
}

#pragma mark -- lazyLoad --

- (void)setBadgeType:(NSInteger)badgeType {
    _badgeType = badgeType;
    switch (badgeType) {
        case 1: {
            self.dataArray = self.viewModel.pkArray;
        }
            break;
        case 2: {
            self.dataArray = self.viewModel.earlyArray;
        }
            break;
        case 3: {
            self.dataArray = self.viewModel.checkInArray;
        }
            break;
        default:
            break;
    }
}

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = ETMainBgColor;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [_mainCollectionView registerNib:NibName(ETMineBadgeCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETMineBadgeCollectionViewCell)];
        
//        WS(weakSelf)
//        _mainCollectionView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
//            [weakSelf.viewModel.refreshPKCommand execute:nil];
//            [weakSelf.viewModel.signStatusCommand execute:nil];
//            [weakSelf.viewModel.myCheckInCommand execute:nil];
//            [NSTimer jk_scheduledTimerWithTimeInterval:2 block:^{
//                [_mainCollectionView.mj_header endRefreshing];
//            } repeats:NO];
//        }];
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 40;
        _layout.minimumInteritemSpacing = 25;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (ETMineBadgeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMineBadgeViewModel alloc] init];
    }
    return _viewModel;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

#pragma mark -- delegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETMineBadgeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETMineBadgeCollectionViewCell) forIndexPath:indexPath];
//    switch (self.badgeType) {
//        case 1: {
//            cell.model = self.viewModel.pkArray[indexPath.row];
//        }
//            break;
//        case 2: {
//            cell.model = self.viewModel.earlyArray[indexPath.row];
//        }
//            break;
//        case 3: {
//            cell.model = self.viewModel.checkInArray[indexPath.row];
//        }
//            break;
//    }
    cell.model = self.dataArray[indexPath.row];
//    cell.model = self.viewModel.dataArray[self.badgeType][indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.jk_width - 100) / 3, ((self.jk_width - 100) / 3) * (190.f / 180.f));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(40, 25, 40, 25);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"index : %@, row : %d , item : %d", indexPath, indexPath.row, indexPath.item);
    
    // 如果点击的项目是健康走(项目ID为35),那么进入排行页面先进行健康数据上传
//    if ([[self.viewModel.pkDataArray[indexPath.row] ProjectID] isEqualToString:@"35"]) {
//        [[ETHealthManager sharedInstance] stepAutomaticUpload];
//    }
//    [self.viewModel.projectCellClickSubject sendNext:[self.viewModel.pkDataArray[indexPath.row] ProjectName]];
    if (self.dataArray.count) {
        [self.viewModel.cellClickSubject sendNext:self.dataArray[indexPath.row]];
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
