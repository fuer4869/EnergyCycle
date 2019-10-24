//
//  ETPKView.m
//  能量圈
//
//  Created by 王斌 on 2017/10/19.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPKView.h"
#import "ETPKViewModel.h"
#import "ETPKHeaderView.h"
#import "ETPKCollectionViewCell.h"

#import "ETRefreshGifHeader.h"

#import "ETHealthManager.h"

#import "ETRemindView.h"

#import "ETPKReportPopView.h"

#import "ETTrainPopView.h"

static NSString * const rightSideImage = @"pk_right_side_tag_red";

static NSString * const reuseIdentifierHeaderView = @"reuseIdentifierHeaderView";


@interface ETPKView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ETRemindViewDelegate, ETTrainPopViewDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) ETPKViewModel *viewModel;

@property (nonatomic, strong) ETPKHeaderView *headerView;

@property (nonatomic, strong) UIButton *rightSideButton;

@end

@implementation ETPKView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETPKViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
//    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf);
//    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf);
//        make.height.equalTo(@163);
        make.height.equalTo(@(kNavHeight + 83));
    }];
    
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.headerView.mas_bottom);
    }];
    
    [self.rightSideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(@-18);
    }];
    
    
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(weakSelf);
//        make.height.equalTo(@200);
//    }];
    
    [super updateConstraints];
}

- (void)et_setupViews {
    [self addSubview:self.headerView];
    [self addSubview:self.mainCollectionView];
    [self addSubview:self.rightSideButton];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshPKCommand execute:nil];
    [self.viewModel.firstEnterDataCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshPKEndSubject subscribeNext:^(id x) {
        @strongify(self)
//        NSString *pkSignUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"PKSignUIUpdate"];
//        if (!pkSignUpdate) {
//            if (@available(iOS 11.0, *)) {
//                [ETRemindView remindImageName:@"remind_pk_signIn_X"];
//            } else {
//                [ETRemindView remindImageName:@"remind_pk_signIn"];
//            }
//            pkSignUpdate = @"2.3";
//            [[NSUserDefaults standardUserDefaults] setObject:pkSignUpdate forKey:@"PKSignUIUpdate"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
        [self.mainCollectionView reloadData];
        [self.mainCollectionView.mj_header endRefreshing];
    }];
    

    
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ReportPKCompleted" object:nil] subscribeNext:^(id x) {
////        @strongify(self)
//        if (@available(iOS 11.0, *)) {
//            [ETRemindView remindImageName:@"remind_pk_report_X"];
//        } else {
//            [ETRemindView remindImageName:@"remind_pk_report"];
//        }
//
////        NSString *pkReportUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"PKReportUIUpdate"];
////        if (!pkReportUpdate) {
////            if (@available(iOS 11.0, *)) {
////                [ETRemindView remindImageName:@"remind_pk_report_X"];
////            } else {
////                [ETRemindView remindImageName:@"remind_pk_report"];
////            }
////            pkReportUpdate = @"2.3";
////            [[NSUserDefaults standardUserDefaults] setObject:pkReportUpdate forKey:@"PKReportUIUpdate"];
////            [[NSUserDefaults standardUserDefaults] synchronize];
////        }
//    }];
}

- (void)popViewClickRemindView {
//    /** 健康数据上传 */
//    [[ETHealthManager sharedInstance] stepAutomaticUpload];
    
    [self.viewModel.remindEndSubject sendNext:nil];
}

#pragma mark -- lazyLoad --

- (UICollectionView *)mainCollectionView {
    if (!_mainCollectionView) {
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = ETMainBgColor;
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [_mainCollectionView registerNib:NibName(ETPKCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETPKCollectionViewCell)];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureHandle:)];
        longGesture.minimumPressDuration = 0.5;
        [_mainCollectionView addGestureRecognizer:longGesture];
        
        WS(weakSelf)
        _mainCollectionView.mj_header = [ETRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf.viewModel.refreshPKCommand execute:nil];
            [weakSelf.viewModel.signStatusCommand execute:nil];
            [weakSelf.viewModel.myCheckInCommand execute:nil];
            [weakSelf.viewModel.myIntegralCommand execute:nil];
            [NSTimer jk_scheduledTimerWithTimeInterval:2 block:^{
                [_mainCollectionView.mj_header endRefreshing];
            } repeats:NO];
        }];
    }
    return _mainCollectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 9;
        _layout.minimumInteritemSpacing = 9;
//        _layout.headerReferenceSize = CGSizeMake(ETScreenW, 163);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (ETPKHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETPKHeaderView) owner:nil options:nil].firstObject initWithViewModel:self.viewModel];
    }
    return _headerView;
}

- (UIButton *)rightSideButton {
    if (!_rightSideButton) {
        _rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightSideButton.adjustsImageWhenHighlighted = NO;
        [_rightSideButton setImage:[UIImage imageNamed:rightSideImage] forState:UIControlStateNormal];
        @weakify(self)
        [[_rightSideButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.rightSideClickSubject sendNext:nil];
        }];
    }
    return _rightSideButton;
}

- (ETPKViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKViewModel alloc] init];
    }
    return _viewModel;
}


#pragma mark -- delegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.pkDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPKCollectionViewCell) forIndexPath:indexPath];
    cell.model = self.viewModel.pkDataArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.jk_width - 27) / 2, ((self.jk_width - 27) / 2) * (111.f / 175.f));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(9, 9, 9, 9);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"index : %@, row : %ld , item : %ld", indexPath, (long)indexPath.row, (long)indexPath.item);
    
//    // 如果点击的项目是健康走(项目ID为35),那么进入排行页面先进行健康数据上传
//    if ([[self.viewModel.pkDataArray[indexPath.row] ProjectID] isEqualToString:@"35"]) {
//        [[ETHealthManager sharedInstance] stepAutomaticUpload];
//    }
    [[ETHealthManager sharedInstance] stepAutomaticUpload];

    ETDailyPKProjectRankListModel *model = self.viewModel.pkDataArray[indexPath.row];
    if ([[model ReportID] integerValue] || [[model Is_Train] boolValue] || [[model ProjectID] isEqualToString:@"35"]) {
//        [self.viewModel.projectCellClickSubject sendNext:self.viewModel.pkDataArray[indexPath.row]];
        [self.viewModel.projectCellClickSubject sendNext:indexPath];
    } else {
        ETPKReportPopView *pkReportPopView = [[ETPKReportPopView alloc] initWithFrame:ETScreenB];
        pkReportPopView.model = model;
        @weakify(self)
        [pkReportPopView.viewModel.reportCompletedSubject subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.refreshPKCommand execute:nil];
        }];
        [ETWindow addSubview:pkReportPopView];
    }
    
//    [self.viewModel.projectCellClickSubject sendNext:indexPath];

}


#pragma mark -- LongGestureHandle --

- (void)longGestureHandle:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:[gesture locationInView:self.mainCollectionView]];
            if (indexPath == nil) {
                break;
            }
            self.viewModel.delCellIndexPath = indexPath;
            ETPKCollectionViewCell *cell = (ETPKCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:self.viewModel.delCellIndexPath];
            ETDailyPKProjectRankListModel *model = self.viewModel.pkDataArray[self.viewModel.delCellIndexPath.row];

            if (cell && [model.Is_CanDel boolValue]) {
                [UIView animateWithDuration:0.1 animations:^{
                    cell.transform = CGAffineTransformMakeScale(0.8, 0.8);
                } completion:^(BOOL finished) {
                    ETTrainPopView *popView = [[ETTrainPopView alloc] initWithTitle:@"提示" Content:[NSString stringWithFormat:@"确定删除“%@”习惯卡吗?\n删除后可在右下角“+”处添加。", model.ProjectName] LeftBtnTitle:@"删除" RightBtnTitle:@"点错了"];
                    popView.delegate = self;
                    [ETWindow addSubview:popView];
                }];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (self.viewModel.delCellIndexPath == nil) {
                break;
            }
            ETPKCollectionViewCell *cell = (ETPKCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:self.viewModel.delCellIndexPath];
            if (cell) {
                [UIView animateWithDuration:0.2 animations:^{
                    cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -- ETTrainPopViewDelegate --

- (void)leftButtonClick:(NSString *)string {
    ETDailyPKProjectRankListModel *model = self.viewModel.pkDataArray[self.viewModel.delCellIndexPath.row];
    // 确认删除
    [MobClick event:@"ETDeleteProject_SureClick" attributes:@{@"ProjectName" : [model ProjectName]}];
    [self.viewModel.projectDelCommand execute:nil];
}

- (void)rightButtonClick:(NSString *)string {
    ETDailyPKProjectRankListModel *model = self.viewModel.pkDataArray[self.viewModel.delCellIndexPath.row];
    // 取消删除
    [MobClick event:@"ETDeleteProject_CancelClick" attributes:@{@"ProjectName" : [model ProjectName]}];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
