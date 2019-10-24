//
//  ETSearchVC.m
//  能量圈
//
//  Created by 王斌 on 2017/6/4.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSearchVC.h"
#import "ETSearchView.h"
#import "ETSearchViewModel.h"
#import "ETSearchRecommendViewModel.h"

#import "ETRecommendUserCollectionViewCell.h"
#import "ETLogPostListTableViewCell.h"
#import "ETInviteTableViewCell.h"
#import "ETPromisePostListTableViewCell.h"

#import "ShareSDKManager.h"

#import "ETWebVC.h"
#import "ETHomePageVC.h"

@interface ETSearchVC () <UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UISearchBar *searchController;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETSearchView *mainView;

@property (nonatomic, strong) UIButton *shadowButton;

@property (nonatomic, strong) ETSearchViewModel *viewModel;

@property (nonatomic, strong) ETSearchRecommendViewModel *tableViewModel;

@end

@implementation ETSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = ETMainBgColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(kStatusBarHeight + kTopBarHeight));
    }];
    
    [self.searchController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.searchView);
        make.top.equalTo(@(kStatusBarHeight));
        make.right.equalTo(weakSelf.cancelButton.mas_left);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(weakSelf.searchController.mas_height);
        make.centerY.equalTo(weakSelf.searchController);
        make.right.equalTo(weakSelf.searchView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    [self.shadowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.contentView];
    [self.searchView addSubview:self.searchController];
    [self.searchView addSubview:self.cancelButton];
    [self.contentView addSubview:self.mainTableView];
    [self.contentView addSubview:self.mainView];
    [self.contentView addSubview:self.shadowButton];
}

- (void)et_bindViewModel {
    @weakify(self)
    [[self.viewModel.dismissSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    [[self.shadowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self hideShadowButton];
    }];
    
    [self.tableViewModel.refreshRecommendDataCommand execute:nil];
    [self.tableViewModel.refreshPostDataCommand execute:nil];
    
    [self.tableViewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.collectionView reloadData];
        [self.mainTableView reloadData];
    }];
    
    [[self.tableViewModel.shareSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
        ETShareModel *shareModel = [[ETShareModel alloc] init];
        shareModel.title = @"能量圈 小习惯，大圈子，新未来";
//        shareModel.content = @"一起加入能量圈吧";
        shareModel.shareUrl = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1079791492";
        
        switch (indexPath.row) {
            case 0: {
                [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatTimeline shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                    if (state == SSDKResponseStateSuccess) {
                        [MBProgressHUD showMessage:@"分享成功"];
                    }
                }];
            }
                break;
            case 1: {
                [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatSession shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                    if (state == SSDKResponseStateSuccess) {
                        [MBProgressHUD showMessage:@"分享成功"];
                    }
                }];
            }
                break;
            case 2: {
                [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformTypeSinaWeibo shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                    if (state == SSDKResponseStateSuccess) {
                        [MBProgressHUD showMessage:@"分享成功"];
                    }
                }];
            }
                break;
            case 3: {
                [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeQQFriend shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                    if (state == SSDKResponseStateSuccess) {
                        [MBProgressHUD showMessage:@"分享成功"];
                    }
                }];
            }
                break;
            case 4: {
                [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeQZone shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                    if (state == SSDKResponseStateSuccess) {
                        [MBProgressHUD showMessage:@"分享成功"];
                    }
                }];
            }
                break;
            default:
                break;
        }
    }];
    
    [self.tableViewModel.attentionSubject subscribeNext:^(NSString *userID) {
        @strongify(self)
        [self.tableViewModel.attentionCommand execute:userID];
        /** 关注后要对数组中的数据进行更新,避免重用时显示出现错误 */
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ETRecommendUserCollectionViewCellViewModel *viewModel in self.tableViewModel.recommendDataArray) {
            if ([viewModel.model.UserID isEqualToString:userID]) {
                viewModel.model.Is_Attention = [NSString stringWithFormat:@"%d", ![viewModel.model.Is_Attention boolValue]];
            }
            [array addObject:viewModel];
        }
        self.tableViewModel.recommendDataArray = array;
    }];
    
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypePost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.viewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [[self.viewModel.userCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(UserModel *model) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [model.UserID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [[self.tableViewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(PostModel *model) {
        ETWebVC *webVC = [[ETWebVC alloc] init];
        webVC.webType = ETWebTypeRecommendPost;
        webVC.model = model;
        webVC.url = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, model.PostID];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[self.tableViewModel.homePageSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *userID) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [userID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [[self.tableViewModel.userCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(UserModel *model) {
        @strongify(self)
        ETHomePageVC *homePageVC = [[ETHomePageVC alloc] init];
        homePageVC.viewModel.userID = [model.UserID integerValue];
        [self.navigationController pushViewController:homePageVC animated:YES];
    }];
    
    [self.tableViewModel.postLikeSubject subscribeNext:^(NSString *postID) {
        @strongify(self)
        [self.viewModel.postLikeCommand execute:postID];
    }];
    
    
}

- (void)et_layoutNavigation {
    [self resetNavigation];

//    self.automaticallyAdjustsScrollViewInsets = YES;
//    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)et_willDisappear {
    [self resetNavigation];
}

- (void)hideShadowButton {
    if (![self.searchController.text isEqualToString:@""]) {
        self.mainTableView.hidden = YES;
        self.mainView.hidden = NO;
    } else {
        self.mainTableView.hidden = NO;
        self.mainView.hidden = YES;
    }
    self.shadowButton.hidden = YES;
    [self.searchController resignFirstResponder];
}

#pragma mark -- lazyLoad --

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = ETMinorBgColor;
    }
    return _searchView;
}

- (UISearchBar *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchBar alloc] init];
        _searchController.placeholder = @"搜索 用户/动态";
        _searchController.delegate = self;
        _searchController.backgroundImage = [UIImage new];
        _searchController.barTintColor = ETMinorBgColor;
        _searchController.backgroundColor = ETMinorBgColor;
        UITextField *searchField = [_searchController valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:ETMinorBgColor];
            if (@available(iOS 11.0, *)) {
                searchField.layer.cornerRadius = 17.f;
            } else {
                searchField.layer.cornerRadius = 13.f;
            }
            searchField.textColor = ETTextColor_First;
//            searchField.layer.borderColor = ETLightBlackColor.CGColor;
            searchField.layer.borderColor = ETGrayColor.CGColor;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
            searchField.font = [UIFont systemFontOfSize:14];
        }
        [_searchController becomeFirstResponder];
    }
    return _searchController;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:ETGrayColor forState:UIControlStateNormal];
        @weakify(self)
        [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
    return _cancelButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ETMinorBgColor;
    }
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 160) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETMainBgColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETRecommendUserCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETRecommendUserCollectionViewCell)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETMainBgColor;
//        _mainTableView.tableHeaderView = self.searchController.searchBar;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:NibName(ETInviteTableViewCell) forCellReuseIdentifier:ClassName(ETInviteTableViewCell)];
        [_mainTableView registerNib:NibName(ETLogPostListTableViewCell) forCellReuseIdentifier:ClassName(ETLogPostListTableViewCell)];
    }
    return _mainTableView;
}

- (ETSearchView *)mainView {
    if (!_mainView) {
        _mainView = [[ETSearchView alloc] initWithViewModel:self.viewModel];
        _mainView.hidden = YES;
    }
    return _mainView;
}

- (UIButton *)shadowButton {
    if (!_shadowButton) {
        _shadowButton = [[UIButton alloc] init];
        _shadowButton.hidden = YES;
    }
    return _shadowButton;
}

- (ETSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSearchViewModel alloc] init];
    }
    return _viewModel;
}

- (ETSearchRecommendViewModel *)tableViewModel {
    if (!_tableViewModel) {
        _tableViewModel = [[ETSearchRecommendViewModel alloc] init];
    }
    return _tableViewModel;
}

#pragma mark -- tableViewDelegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return self.tableViewModel.postDataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section ? [[UIView alloc] init] : self.collectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section ? 0.01f : 160.f ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ETInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETInviteTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shareType = indexPath.row;
        return cell;
    }
    ETLogPostListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETLogPostListTableViewCell) forIndexPath:indexPath];
    cell.viewModel = self.tableViewModel.postDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kNavHeight;
    }
//    return [tableView fd_heightForCellWithIdentifier:ClassName(ETLogPostListTableViewCell) configuration:^(ETLogPostListTableViewCell *cell) {
//        cell.fd_enforceFrameLayout = NO;
//        cell.viewModel = self.tableViewModel.postDataArray[indexPath.row];
//    }];
    return [tableView fd_heightForCellWithIdentifier:ClassName(ETLogPostListTableViewCell) cacheByIndexPath:indexPath configuration:^(ETLogPostListTableViewCell *cell) {
        cell.fd_enforceFrameLayout = NO;
        cell.viewModel = self.tableViewModel.postDataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self.tableViewModel.shareSubject sendNext:indexPath];
    } else {
        [self.tableViewModel.cellClickSubject sendNext:[self.tableViewModel.postDataArray[indexPath.row] model]];
    }
}

#pragma mark -- UICollectionView Delegate DataSource --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tableViewModel.recommendDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETRecommendUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETRecommendUserCollectionViewCell) forIndexPath:indexPath];
    cell.viewModel = self.tableViewModel.recommendDataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 140);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableViewModel.userCellClickSubject sendNext:[self.tableViewModel.recommendDataArray[indexPath.row] model]];
}


#pragma mark -- UISearchResultsUpdating --

#pragma mark -- UISearchBarDelegate --

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.shadowButton.hidden = NO;
    return YES;
}

//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    if ([searchBar.text isEqualToString:@""]) {
//        self.mainView.hidden = YES;
//        self.mainTableView.hidden = NO;
//    }
//    return YES;
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.viewModel.searchKey = searchBar.text;
    [self.viewModel.refreshUserDataCommand execute:nil];
    [self.viewModel.refreshPostDataCommand execute:nil];
//    self.mainTableView.hidden = YES;
//    self.shadowButton.hidden = YES;
//    self.mainView.hidden = NO;
    [self hideShadowButton];
}


#pragma mark --

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
