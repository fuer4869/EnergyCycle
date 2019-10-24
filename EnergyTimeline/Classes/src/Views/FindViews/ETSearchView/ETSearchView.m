//
//  ETSearchView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSearchView.h"
#import "ETSearchViewModel.h"
#import "ETUserTableViewCell.h"
#import "ETLogPostListTableViewCell.h"
#import "ETPromisePostListTableViewCell.h"

@interface ETSearchView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETSearchViewModel *viewModel;

@end

@implementation ETSearchView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETSearchViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.attentionSubject subscribeNext:^(NSString *userID) {
        @strongify(self)
        [self.viewModel.attentionCommand execute:userID];
        /** 关注后要对数组中的数据进行更新,避免重用是显示出现错误 */
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ETSearchUserTableViewCellViewModel *viewModel in self.viewModel.userDataArray) {
            if ([viewModel.model.UserID isEqualToString:userID]) {
                viewModel.model.Is_Attention = [NSString stringWithFormat:@"%d", ![viewModel.model.Is_Attention boolValue]];
            }
            [array addObject:viewModel];
        }
        self.viewModel.userDataArray = array;
    }];
    
    [self.viewModel.postLikeSubject subscribeNext:^(NSString *postID) {
        @strongify(self)
        [self.viewModel.postLikeCommand execute:postID];
    }];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMainBgColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETUserTableViewCell) forCellReuseIdentifier:ClassName(ETUserTableViewCell)];
        [_mainTableView registerNib:NibName(ETLogPostListTableViewCell) forCellReuseIdentifier:ClassName(ETLogPostListTableViewCell)];
    }
    return _mainTableView;
}

#pragma mark -- tableViewDelegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? 5.f : 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? self.viewModel.postDataArray.count : self.viewModel.userDataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [tableView deselectSectionCell:cell CornerRadius:10 forRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        ETUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETUserTableViewCell) forIndexPath:indexPath];
        cell.searchUserViewModel = self.viewModel.userDataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    ETLogPostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETLogPostListTableViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel.postDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 75;
    }
//    return [tableView fd_heightForCellWithIdentifier:ClassName(ETLogPostListTableViewCell) configuration:^(ETLogPostListTableViewCell *cell) {
//        cell.fd_enforceFrameLayout = NO;
//        cell.viewModel = self.viewModel.postDataArray[indexPath.row];
//    }];
    return [tableView fd_heightForCellWithIdentifier:ClassName(ETLogPostListTableViewCell) cacheByIndexPath:indexPath configuration:^(ETLogPostListTableViewCell *cell) {
        cell.fd_enforceFrameLayout = NO;
        cell.viewModel = self.viewModel.postDataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [self.viewModel.userCellClickSubject sendNext:[self.viewModel.userDataArray[indexPath.row] model]];
    } else {
        [self.viewModel.cellClickSubject sendNext:[self.viewModel.postDataArray[indexPath.row] model]];
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
