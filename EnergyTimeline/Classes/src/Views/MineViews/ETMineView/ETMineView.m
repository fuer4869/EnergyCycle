//
//  ETMineView.m
//  能量圈
//
//  Created by 王斌 on 2017/6/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETMineView.h"
#import "ETMineHeaderView.h"
#import "ETMineTableViewCell.h"

#import "ETRemindView.h"

@interface ETMineView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETMineHeaderView *headerView;

@property (nonatomic, strong) ETMineViewModel *viewModel;

@end

@implementation ETMineView

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETMineViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.firstEnterDataCommand execute:nil];

    @weakify(self)    
    [[self.viewModel.refreshUserModelSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        self.headerView.viewModel = self.viewModel;
        [self.mainTableView reloadData];
        
    }];
//    NSString *setupUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MineSetupUIUpdate"];
//
//    if (!setupUpdate) {
//        if (@available(iOS 11.0, *)) {
//            [ETRemindView remindImageName:@"remind_mine_setup_X"];
//        } else {
//            [ETRemindView remindImageName:@"remind_mine_setup"];
//        }
//        setupUpdate = @"2.3";
//        [[NSUserDefaults standardUserDefaults] setObject:setupUpdate forKey:@"MineSetupUIUpdate"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    [self.viewModel.firstEnterEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (![self.viewModel.firstEnterModel.Is_FirstEditProfile_Remind boolValue]) {
            if (@available(iOS 11.0, *)) {
                [ETRemindView remindImageName:@"remind_mine_setup_X"];
            } else {
                [ETRemindView remindImageName:@"remind_mine_setup"];
            }
            [self.viewModel.firstEnterUpdCommand execute:@"Is_FirstEditProfile_Remind"];
        }
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
        _mainTableView.tableHeaderView = self.headerView;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerNib:NibName(ETMineTableViewCell) forCellReuseIdentifier:ClassName(ETMineTableViewCell)];
    }
    return _mainTableView;
}

- (ETMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:ClassName(ETMineHeaderView) owner:nil options:nil].lastObject initWithViewModel:self.viewModel];
        _headerView.layer.zPosition = -1;
    }
    return _headerView;
}

- (ETMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETMineViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- delegate --

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return section ? 3 : 2;
//    return 3;
    return 7;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return section ? 4 : 0.01;
//}
//

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return section ? 10 : 0.01;
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        [tableView deselectSectionCell:cell CornerRadius:10 forRowAtIndexPath:indexPath];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETMineTableViewCell) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.viewModel = self.viewModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IsiPhoneX ? 82.f : 64.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel.cellClickSubject sendNext:indexPath];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
