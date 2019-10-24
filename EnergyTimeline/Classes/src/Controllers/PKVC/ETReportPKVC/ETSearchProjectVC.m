//
//  ETSearchProjectVC.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETSearchProjectVC.h"
#import "ETSearchProjectView.h"

#import "ZJScrollPageView.h"
#import "ETProjectTypeVC.h"

#import "ETPKProjectTypeModel.h"

#import "SetProjectVC.h"

#import "ETNewCustomProjectView.h" // 自定义习惯

#import "ETPKReportPopView.h" // 汇报

#import "ETTrainTargetVC.h" // 训练界面

@interface ETSearchProjectVC () <ZJScrollPageViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) ZJSegmentStyle *style;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property (nonatomic, strong) ETSearchProjectView *mainView;

@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *finishButton;

@end

@implementation ETSearchProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMinorBgColor;
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
//    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(weakSelf.view);
//        make.height.equalTo(@(kStatusBarHeight + kTopBarHeight));
//    }];
//
//    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@50);
//        make.height.equalTo(weakSelf.searchController.mas_height);
//        make.centerY.equalTo(weakSelf.searchController);
//        make.left.equalTo(weakSelf.searchView);
//    }];
//
//    [self.searchController mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.searchView);
//        make.top.equalTo(@(kStatusBarHeight));
//        make.left.equalTo(weakSelf.backButton.mas_right);
//        make.right.equalTo(weakSelf.finishButton.mas_left);
//    }];
//
//    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@50);
//        make.height.equalTo(weakSelf.searchController.mas_height);
//        make.centerY.equalTo(weakSelf.searchController);
//        make.right.equalTo(weakSelf.searchView);
//    }];
//
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.searchView.mas_bottom);
//        make.left.right.bottom.equalTo(weakSelf.view);
//    }];
//
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.contentView);
//    }];
    
//    [self.scrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.view);
//    }];
    
//    WS(weakSelf)
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
//    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view).with.offset(30);
//        make.right.equalTo(weakSelf.view).with.offset(-30);
//        make.bottom.equalTo(weakSelf.view).with.offset(-(30.f + kSafeAreaBottomHeight));
//        make.height.equalTo(@50);
//    }];
    
    [super updateViewConstraints];
}

- (void)et_getNewData {
    @weakify(self)
    [[self.viewModel.refreshDataCommand execute:nil] subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            if (self.viewModel.titleArray.count) {
//                [self.view addSubview:self.scrollPageView];
                NSMutableArray *typeImage = [[NSMutableArray alloc] init];
                for (ETPKProjectTypeModel *typeModel in self.viewModel.projectTypeArray) {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[NSURL URLWithString:typeModel.FilePath]
                                          options:0
                                         progress:nil
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            if (image) {
                                                [typeImage addObject:image];
                                                if (typeImage.count == self.viewModel.projectTypeArray.count) {
                                                    self.viewModel.typeImageArray = typeImage;
                                                    [self.view addSubview:self.scrollPageView];
                                                }
                                            }
                                        }];
                }

            }
        }
    }];
}

- (void)et_addSubviews {
//    [self.view addSubview:self.searchView];
//    [self.view addSubview:self.contentView];
//    [self.searchView addSubview:self.searchController];
//    [self.searchView addSubview:self.backButton];
//    [self.searchView addSubview:self.finishButton];
//    [self.contentView addSubview:self.collectionView];
//    [self.contentView addSubview:self.mainView];

    [self.view addSubview:self.mainView];
//    [self.view addSubview:self.finishButton];

//    [self.view setNeedsUpdateConstraints];
//    [self.view updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    @weakify(self)
//    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
//        @strongify(self)
//        self.scrollPageView.hidden = self.viewModel.isSearch;
//        self.mainView.hidden = !self.viewModel.isSearch;
//    }];
    
    [self.viewModel.searchEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.scrollPageView.hidden = self.viewModel.isSearch;
//        self.finishButton.hidden = self.viewModel.isSearch;
        self.mainView.hidden = !self.viewModel.isSearch;
    }];
    
    [self.viewModel.selectProjectSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.viewModel.promiseSetProjectSubject subscribeNext:^(ETPKProjectModel *model) {
        @strongify(self)
        SetProjectVC *setVC = [[SetProjectVC alloc] init];
        setVC.model = model;
        [self.navigationController pushViewController:setVC animated:YES];
    }];
    
    [self.viewModel.newProejctSubject subscribeNext:^(id x) {
        @strongify(self)
        // 点击了点击添加
        [MobClick event:@"ETSearchProject_AddClick"];
        ETNewCustomProjectView *newProjectView = [[ETNewCustomProjectView alloc] init];
        [newProjectView.viewModel.setNameSubject sendNext:self.viewModel.searchKey];
        [newProjectView.viewModel.completedSubject subscribeNext:^(id x) {
            @strongify(self)
            if (self.viewModel.isPromise) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [ETWindow addSubview:newProjectView];
    }];
    
    [self.viewModel.reportPKSubject subscribeNext:^(ETDailyPKProjectRankListModel *model) {
        @strongify(self)
        if ([model.Is_Train boolValue]) {
            ETTrainTargetVC *targetVC = [[ETTrainTargetVC alloc] init];
            targetVC.viewModel.projectID = [model.ProjectID integerValue];
            [self presentViewController:targetVC animated:YES completion:nil];
        } else {
            ETPKReportPopView *pkReportPopView = [[ETPKReportPopView alloc] initWithFrame:ETScreenB];
            pkReportPopView.model = model;
            [pkReportPopView.viewModel.reportCompletedSubject subscribeNext:^(id x) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [ETWindow addSubview:pkReportPopView];
        }
    }];
    
    [[self.finishButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.selectArray.count) {
            [self.viewModel.selectProjectSubject sendNext:self.viewModel.selectArray];
        } else {
            [MBProgressHUD showMessage:@"至少选择一个项目"];
        }
    }];
    
}

- (void)et_layoutNavigation {
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    self.navigationItem.titleView = self.searchBar;
    [self setupRightNavBarWithTitle:@"创建"];
}

- (void)leftAction {
//    if (![self.viewModel.searchKey isEqualToString:@""] && self.viewModel.searchKey) {
//        self.scrollPageView.hidden = !self.viewModel.isSearch;
//        self.finishButton.hidden = !self.viewModel.isSearch;
//        self.mainView.hidden = self.viewModel.isSearch;
//        [self.viewModel.refreshDataCommand execute:nil];
//        self.searchBar.text = @"";
//        self.viewModel.searchKey = self.searchBar.text;
//        [self setupRightNavBarWithTitle:@"创建"];
//        [self.searchBar resignFirstResponder];
//
////        self.scrollPageView.hidden = !self.viewModel.isSearch;
////        self.finishButton.hidden = !self.viewModel.isSearch;
////        self.mainView.hidden = self.viewModel.isSearch;
////        [self.viewModel.refreshDataCommand execute:nil];
////        [self setupRightNavBarWithTitle:@"创建"];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    // 判断是否是搜索状态
    if (self.viewModel.isSearch) {
        self.scrollPageView.hidden = !self.viewModel.isSearch;
//        self.finishButton.hidden = !self.viewModel.isSearch;
        self.mainView.hidden = self.viewModel.isSearch;
        [self.viewModel.refreshDataCommand execute:nil];
        self.searchBar.text = @"";
        self.viewModel.searchKey = self.searchBar.text;
        [self setupRightNavBarWithTitle:@"创建"];
        [self.searchBar resignFirstResponder];
        self.searchBar.placeholder = @"搜索";

    } else {
//        [self.navigationController popViewControllerAnimated:YES];
        if (self.viewModel.isPromise) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)rightAction {
//    if (self.viewModel) {
//        <#statements#>
//    }
//    if (![self.viewModel.searchKey isEqualToString:@""] && self.viewModel.searchKey) {
    if (self.viewModel.isSearch) {
//        NSLog(@"确定");
//        if (self.viewModel.selectArray.count) {
//            [self.viewModel.selectProjectSubject sendNext:self.viewModel.selectArray];
//        } else {
//            [MBProgressHUD showMessage:@"至少选择一个项目"];
//        }
        NSLog(@"取消");
        self.scrollPageView.hidden = !self.viewModel.isSearch;
        self.mainView.hidden = self.viewModel.isSearch;
        [self.viewModel.refreshDataCommand execute:nil];
        self.searchBar.text = @"";
        self.viewModel.searchKey = self.searchBar.text;
        [self setupRightNavBarWithTitle:@"创建"];
        [self.searchBar resignFirstResponder];
        self.searchBar.placeholder = @"搜索";
    } else {
        // 点击了创建按钮
        [MobClick event:@"ETSearchProject_CreateClick"];
        NSLog(@"创建");
//        [self.viewModel.newProejctSubject sendNext:nil];
        [self.searchBar becomeFirstResponder];
//        [self presentViewController:newCustomVC animated:YES completion:nil];
//        if (self.viewModel.selectArray.count) {
//            [self.viewModel.selectProjectSubject sendNext:self.viewModel.selectArray];
//        } else {
//            [MBProgressHUD showMessage:@"至少选择一个项目"];
//        }
    }
}

- (void)et_willDisappear {
    [self resetNavigation];
}

#pragma mark -- lazyLoad --
//
//- (ZJSegmentStyle *)style {
//    if (!_style) {
//        _style = [[ZJSegmentStyle alloc] init];
//        _style.showCover = YES;
//        _style.scrollTitle = NO;
//        _style.titleFont = [UIFont systemFontOfSize:12];
//        _style.gradualChangeTitleColor = YES; // 开启颜色渐变,但是同时默认字体颜色和选择时字体颜色必须使用RGB颜色,否则程序崩溃
//        //        _style.coverBackgroundColor = [UIColor jk_colorWithHexString:segmentViewColorHexString];
//        _style.normalTitleColor = [UIColor jk_colorWithWholeRed:149 green:160 blue:171];
//        _style.selectedTitleColor = [UIColor jk_colorWithWholeRed:255 green:255 blue:255];
//    }
//    return _style;
//}

- (ZJSegmentStyle *)style {
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
        _style.showLine = YES;
        _style.showImage = YES;
//        _style.showLeftExtraButton = YES;
//        _style.showExtraButton = YES;
        _style.imagePosition = TitleImagePositionLeft;
        // 当标题(和图片)宽度总和小于ZJScrollPageView的宽度的时候, 标题会自适应宽度
        _style.autoAdjustTitlesWidth = YES;
        _style.scrollLineHeight = 2;
        _style.scrollLineColor = ETWhiteColor;
        _style.titleFont = [UIFont systemFontOfSize:14];
        _style.normalTitleColor = ETTextColor_Third;
        _style.selectedTitleColor = ETTextColor_First;
//        _style.leftExtraBtnBackgroundImageName = ETWhiteBack;
//        _style.extraBtnBackgroundImageName = @"more_white";
    }
    return _style;
}

- (ZJScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0.0, 0.0, ETScreenW, ETScreenH - kNavHeight) segmentStyle:self.style titles:self.viewModel.titleArray parentViewController:self delegate:self];
        _scrollPageView.backgroundColor = ETMainBgColor;
//        _scrollPageView.contentView.backgroundColor = [UIColor clearColor];
//        _scrollPageView.contentView.collectionView.backgroundColor = [UIColor clearColor];
        _scrollPageView.segmentView.backgroundColor = ETMinorBgColor;
        
        //        WS(weakSelf)
        //        _scrollPageView.leftExtraBtnOnClick = ^(UIButton *leftExtraBtn) {
        //            [weakSelf.navigationController popViewControllerAnimated:YES];
        //        };
        //        _scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn) {
        //            [weakSelf.view addSubview:weakSelf.pageListView];
        //            weakSelf.scrollPageView.segmentView.alpha = 0;
        //            [weakSelf updateViewConstraints];
        //        };
//        _scrollPageView.hidden = YES;
    }
    return _scrollPageView;
}

- (ETSearchProjectView *)mainView {
    if (!_mainView) {
        _mainView = [[ETSearchProjectView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.barTintColor = ETMinorBgColor;
        _searchBar.backgroundColor = ETMinorBgColor;
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:ETMinorBgColor];
            if (@available(iOS 11.0, *)) {
                searchField.layer.cornerRadius = 17.f;
            } else {
                searchField.layer.cornerRadius = 13.f;
            }
            searchField.textColor = ETTextColor_First;
            searchField.layer.borderColor = ETGrayColor.CGColor;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
            searchField.font = [UIFont systemFontOfSize:14];
        }
       if (@available(iOS 11.0, *)) {
            [[_searchBar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
        }
//        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

- (ETSearchProjectViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETSearchProjectViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
        [_finishButton setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        [_finishButton setBackgroundColor:ETMinorColor];
        _finishButton.layer.cornerRadius = 25;
    }
    return _finishButton;
}

#pragma mark -- delegate --

- (NSInteger)numberOfChildViewControllers {
    return self.viewModel.dataArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(ETProjectTypeVC<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    self.viewModel.currentIndex = index;
    ETProjectTypeVC<ZJScrollPageViewChildVcDelegate> *childVC = reuseViewController;
//    childVC.view.backgroundColor = [UIColor clearColor];
    if (!childVC) {
        childVC = [[ETProjectTypeVC alloc] initWithViewModel:self.viewModel];
        childVC.typeIndex = index;
    }
    
    return childVC;
}

- (void)setUpTitleView:(ZJTitleView *)titleView forIndex:(NSInteger)index {
    titleView.normalImage = self.viewModel.typeImageArray[index];
    titleView.imageViewSize = CGSizeMake(15, 15);
    titleView.imageViewConentMode = UIViewContentModeScaleAspectFit;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(ETProjectTypeVC *)childViewController forIndex:(NSInteger)index {
    [self.viewModel.refreshEndSubject sendNext:[NSNumber numberWithInteger:index]];
//    NSDictionary *dic = @{@"ProjectName" : self.viewModel.titleArray[index]};
//    [MobClick event:@"ETDailyPKPageVCClick" attributes:dic];
//    if (childViewController.viewModel.headerViewModel.model && childViewController.viewModel.headerViewModel.model.PKCoverImg) {
//        [self.bgImage sd_setImageWithURL:[NSURL URLWithString:childViewController.viewModel.headerViewModel.model.PKCoverImg]];
//    } else {
//        [self.bgImage setImage:[UIImage imageNamed:ETUserPKCoverImg_Default]];
//    }
}

#pragma mark -- UISearchBarDelegate --

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.viewModel.isSearch = YES;
    self.scrollPageView.hidden = YES;
//    self.finishButton.hidden = YES;
    [self setupRightNavBarWithTitle:@"取消 "];
    self.searchBar.placeholder = @"请输入习惯名称";

    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.viewModel.searchKey = searchBar.text;
    [self.viewModel.searchDataCommand execute:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.viewModel.searchKey = searchBar.text;
//    if ([self.viewModel.searchKey isEqualToString:@""]) {
//        self.scrollPageView.hidden = !self.viewModel.isSearch;
//        self.finishButton.hidden = !self.viewModel.isSearch;
//        self.mainView.hidden = self.viewModel.isSearch;
//        [self.viewModel.refreshDataCommand execute:nil];
//        [self setupRightNavBarWithTitle:@"创建"];
//    } else {
    if ([self.viewModel.searchKey isEqualToString:@""]) {
        self.mainView.hidden = YES;
    } else {
        self.mainView.hidden = NO;
        [self.viewModel.searchDataCommand execute:nil];
    }
//        [self setupRightNavBarWithTitle:@"确定"];
//    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

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
