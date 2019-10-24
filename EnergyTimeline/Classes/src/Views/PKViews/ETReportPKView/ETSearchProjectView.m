//
//  ETSearchProjectView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSearchProjectView.h"
#import "ETSearchProjectViewModel.h"
#import "ETProjectCollectionViewCell.h"
#import "ETSearchProjectTableViewCell.h"
#import "ETSearchNotFoundTableViewCell.h"

@interface ETSearchProjectView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

//@property (nonatomic, strong) 

@property (nonatomic, strong) ETSearchProjectViewModel *viewModel;

@end

@implementation ETSearchProjectView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
//    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf);
//    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETSearchProjectViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
//    [self addSubview:self.mainCollectionView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
//    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
//        [self.mainTableView reloadData];
        [self.mainCollectionView reloadData];
    }];
    
    [self.viewModel.searchEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
    }];
}

#pragma mark -- lazyLoad --

- (ETSearchProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSearchProjectViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _mainTableView.hidden = YES;
//        _mainTableView.tableHeaderView = self.headerView;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:NibName(ETSearchProjectTableViewCell) forCellReuseIdentifier:ClassName(ETSearchProjectTableViewCell)];
        [_mainTableView registerNib:NibName(ETSearchNotFoundTableViewCell) forCellReuseIdentifier:ClassName(ETSearchNotFoundTableViewCell)];
    }
    return _mainTableView;
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

#pragma mark -- tableView delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.isSearch ? 1 : self.viewModel.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.isSearch ? (self.viewModel.searchDataArray.count ? self.viewModel.searchDataArray.count : 1) : [self.viewModel.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.viewModel.isSearch ? 0.01 : 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.viewModel.isSearch ? 0.01 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewModel.isSearch) {
        return [[UIView alloc] init];
    }
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 20)];
    headerSectionView.backgroundColor = ETProjectRelatedBGColor;
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = ETMinorColor;
    [headerSectionView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerSectionView).with.offset(18);
        make.bottom.equalTo(headerSectionView);
        make.width.equalTo(@4);
        make.height.equalTo(@14);
    }];
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = self.viewModel.dataArray[section][@"ProjectTypeName"];
    rightLabel.textColor = ETTextColor_First;
    [rightLabel setFont:[UIFont systemFontOfSize:12]];
    [headerSectionView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).with.offset(6);
        make.centerY.equalTo(leftView);
    }];
    return headerSectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.viewModel.isSearch) {
        return [[UIView alloc] init];
    }
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = ETMinorBgColor;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.isSearch && !self.viewModel.searchDataArray.count) {
        ETSearchNotFoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETSearchNotFoundTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.viewModel = self.viewModel;
        return cell;
    }
    ETSearchProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETSearchProjectTableViewCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.viewModel.isSearch) {
        cell.stateType = ETProjectCellStateTypeUnCheck;
        ETPKProjectModel *model = self.viewModel.searchDataArray[indexPath.row];
        for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
            if ([selectModel.ProjectID isEqualToString:model.ProjectID]) {
                cell.stateType = ETProjectCellStateTypeCheck;
            }
        }
        cell.model = model;
    } else {
        cell.stateType = ETProjectCellStateTypeUnCheck;
        ETPKProjectModel *model = self.viewModel.dataArray[indexPath.section][@"ProjectList"][indexPath.row];
        for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
            if ([selectModel.ProjectID isEqualToString:model.ProjectID]) {
                cell.stateType = ETProjectCellStateTypeCheck;
            }
        }
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.viewModel.isPromise) {
//        [self.viewModel.promiseSetProjectSubject sendNext:self.viewModel.searchDataArray[indexPath.row]];
//        return;
//    }
    if (self.viewModel.isSearch) {
        if (!self.viewModel.searchDataArray.count) {
            [self.viewModel.newProejctSubject sendNext:nil];
            return;
        }
        
        if (self.viewModel.isPromise) {
            [self.viewModel.promiseSetProjectSubject sendNext:self.viewModel.searchDataArray[indexPath.row]];
            return;
        }
        
        [self.viewModel.reportPKSubject sendNext:self.viewModel.searchDataArray[indexPath.row]];
        return;
        
//        ETSearchProjectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (cell.stateType == ETProjectCellStateTypeUnCheck) {
//            [self.viewModel.selectArray addObject:self.viewModel.searchDataArray[indexPath.row]];
////            [self.viewModel.selectProjectSubject sendNext:self.viewModel.selectArray];
//            cell.stateType = ETProjectCellStateTypeCheck;
//        } else if (cell.stateType == ETProjectCellStateTypeCheck) {
//            ETPKProjectModel *model = self.viewModel.searchDataArray[indexPath.row];
//            for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
//                if ([model.ProjectID isEqualToString:selectModel.ProjectID]) {
//                    [self.viewModel.selectArray removeObject:selectModel];
//                    cell.stateType = ETProjectCellStateTypeUnCheck;
//                    return;
//                }
//            }
//        }
    } else {
        ETSearchProjectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.stateType == ETProjectCellStateTypeUnCheck) {
            cell.stateType = ETProjectCellStateTypeCheck;
            [self.viewModel.selectArray addObject:self.viewModel.dataArray[indexPath.section][@"ProjectList"][indexPath.row]];
        } else if (cell.stateType == ETProjectCellStateTypeCheck) {
            ETPKProjectModel *model = self.viewModel.dataArray[indexPath.section][@"ProjectList"][indexPath.row];
            for (ETPKProjectModel *selectModel in self.viewModel.selectArray) {
                if ([model.ProjectID isEqualToString:selectModel.ProjectID]) {
                    [self.viewModel.selectArray removeObject:selectModel];
                    cell.stateType = ETProjectCellStateTypeUnCheck;
                    return;
                }
            }
        }
    }
}

#pragma mark -- delegate and dataSource --

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.dataArray.count ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETProjectCollectionViewCell) forIndexPath:indexPath];
    ETPKProjectModel *model = self.viewModel.dataArray[indexPath.section][indexPath.row];
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
    //    NSLog(@"%@", self.viewModel.dataArray[indexPath.row]);
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
