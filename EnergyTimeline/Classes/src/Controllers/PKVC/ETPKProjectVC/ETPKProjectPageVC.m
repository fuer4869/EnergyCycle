//
//  ETPKProjectPageVC.m
//  能量圈
//
//  Created by 王斌 on 2018/1/10.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETPKProjectPageVC.h"
#import "ETPKProjectVC.h"
#import "ETPKCustomProjectVC.h"
#import "ZJScrollPageView.h"
#import "ETPKProjectPageListView.h"

#import "ETRemindView.h"
#import "ETPopView.h"

/** 图片压缩 */
#import "UIImage+Compression.h"

static NSString * const projectListMore = @"pk_projectRank_more";
static NSString * const projectListClose = @"pk_projectRank_cancel_white";

@interface ETPKProjectPageVC () <ZJScrollPageViewDelegate, ETPopViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) ZJSegmentStyle *topStyle;

@property (nonatomic, strong) ZJSegmentStyle *bottomStyle;

@property (nonatomic, strong) ZJScrollSegmentView *topSegmentView;

@property (nonatomic, strong) ZJScrollSegmentView *bottomSegmentView;

@property (nonatomic, strong) ZJContentView *contentView;

@property (nonatomic, strong) ETPKProjectPageListView *projectListView;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation ETPKProjectPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    
    if (self.viewModel.addSubviews) {
        [self.topSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(weakSelf.view);
            make.height.equalTo(@36);
        }];
        
        [self.bottomSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakSelf.view);
            make.height.equalTo(@3);
        }];
    }
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    if (self.viewModel.allProject) {
        @weakify(self)
        [[self.viewModel.projectListCommand execute:nil] subscribeNext:^(id x) {
            @strongify(self)
            self.viewModel.addSubviews = YES;
            [self.view addSubview:self.topSegmentView];
            [self.view addSubview:self.bottomSegmentView];
            [self.view addSubview:self.contentView];
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraintsIfNeeded];
        }];
    } else {
        self.viewModel.addSubviews = YES;
        [self.view addSubview:self.topSegmentView];
        [self.view addSubview:self.bottomSegmentView];
        [self.view addSubview:self.contentView];
        
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
    }
}

//- (void)et_getNewData {
//    if (self.viewModel.allProject) {
//        @weakify(self)
//        [[self.viewModel.projectListCommand execute:nil] subscribeNext:^(id x) {
//            @strongify(self)
//            [self.view addSubview:self.topSegmentView];
//            [self.view addSubview:self.bottomSegmentView];
//            [self.view addSubview:self.contentView];
//            [self.view setNeedsUpdateConstraints];
//            [self.view updateConstraintsIfNeeded];
//        }];
//    }
//}

- (void)et_bindViewModel {
    @weakify(self)
    [self.viewModel.firstEnterDataCommand execute:nil];
    [self.viewModel.projectTypeListCommand execute:nil];
    
    [self.viewModel.firstEnterEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (![self.viewModel.firstEnterModel.Is_PK_Guide boolValue]) {
            if (@available(iOS 11.0, *)) {
                [ETRemindView remindImageName:@"remind_pk_projectPage_X"];
            } else {
                [ETRemindView remindImageName:@"remind_pk_projectPage"];
            }
            [self.viewModel.firstEnterUpdCommand execute:@"Is_PK_Guide"];
        }
    }];
    
    [[self.viewModel.projectListCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *number) {
        @strongify(self)
        [self.viewModel.removeProjectListViewSubject sendNext:nil];
        [self.topSegmentView setSelectedIndex:[number integerValue] animated:YES];
        [self.bottomSegmentView setSelectedIndex:[number integerValue] animated:YES];
    }];
    
    [[self.viewModel.removeProjectListViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [_topSegmentView.extraBtn setImage:[UIImage imageNamed:projectListMore] forState:UIControlStateNormal];
        [self.projectListView removeFromSuperview];
        self.projectListView = nil;
    }];
    
    [[self.viewModel.setupPKCoverSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self selectPhotos];
    }];
    
    [[self.viewModel.backSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self leftAction];
    }];
}

- (void)et_layoutNavigation {
    self.view.backgroundColor = ETMinorBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupLeftNavBarWithimage:ETLeftArrow_Gray];
    if (!self.viewModel.allProject) {
        [self setupRightNavBarWithimage:@"trash_red"];
    }
}

- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction {
    [ETPopView popViewWithDelegate:self Title:@"提示" Tip:@"确定删除此项目" SureBtnTitle:@"确定" CancelBtnTitle:@"取消"];
}

- (void)popViewClickSureBtn {
//    NSLog(@"删除%@", self.viewModel.dataArray[self.viewModel.currentIndex]);
    [self.viewModel.projectDelCommand execute:nil];
}

- (void)selectPhotos {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置PK封面" message:@"您可先设置封面,当成您成为第一名时自动替换该封面" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- pickerDelegate navigationDelegate --

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationController.navigationBar.translucent = NO;
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [viewController.navigationController.navigationBar setShadowImage:[UIImage new]];
    viewController.navigationController.navigationBar.layer.shadowColor = ETWhiteColor.CGColor;
    viewController.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    viewController.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *resultImage = [UIImage compressImage:image toKilobyte:1024];
    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.5);
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self.viewModel.uploadPKCoverImgCommand execute:imageData];
}

#pragma mark -- lazyLoad --

- (ZJSegmentStyle *)topStyle {
    if (!_topStyle) {
        _topStyle = [[ZJSegmentStyle alloc] init];
        _topStyle.showLine = YES;
        _topStyle.showExtraButton = YES;
        _topStyle.titleMargin = 26;
        _topStyle.titleFont = [UIFont systemFontOfSize:15];
        _topStyle.scrollLineHeight = 2;
        _topStyle.scrollLineColor = ETMarkYellowColor;
        _topStyle.normalTitleColor = ETTextColor_First;
        _topStyle.selectedTitleColor = ETTextColor_First;
        _topStyle.extraBtnBackgroundImageName = projectListMore;
    }
    return _topStyle;
}

- (ZJSegmentStyle *)bottomStyle {
    if (!_bottomStyle) {
        _bottomStyle = [[ZJSegmentStyle alloc] init];
        _bottomStyle.showLine = YES;
        _bottomStyle.scrollTitle = NO;
        _bottomStyle.scrollLineHeight = 3;
        _bottomStyle.scrollLineColor = ETMarkYellowColor;
        _bottomStyle.normalTitleColor = ETClearColor;
        _bottomStyle.selectedTitleColor = ETClearColor;
    }
    return _bottomStyle;
}

- (ZJScrollSegmentView *)topSegmentView {
    if (!_topSegmentView) {
        WS(weakSelf)
        _topSegmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 36) segmentStyle:self.topStyle delegate:self titles:self.viewModel.titleArray titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
        }];
        _topSegmentView.hidden = !self.viewModel.allProject;
        _topSegmentView.extraBtnOnClick = ^(UIButton *extraBtn) {
            if (weakSelf.viewModel.showProjectList) {
                [weakSelf.viewModel.removeProjectListViewSubject sendNext:nil];
            } else {
                [extraBtn setImage:[UIImage imageNamed:projectListClose] forState:UIControlStateNormal];
                [weakSelf.view addSubview:weakSelf.projectListView];
                [weakSelf.projectListView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(weakSelf.view);
                    make.top.equalTo(weakSelf.view).with.offset(36);
                }];
            }
            weakSelf.viewModel.showProjectList = !weakSelf.viewModel.showProjectList;
        };
    }
    return _topSegmentView;
}

- (ZJScrollSegmentView *)bottomSegmentView {
    if (!_bottomSegmentView) {
        WS(weakSelf)
        _bottomSegmentView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, ETScreenW, 3) segmentStyle:self.bottomStyle delegate:(self.viewModel.allProject ? nil : self) titles:self.viewModel.titleArray titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            if (!weakSelf.viewModel.allProject) {
                [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
            }

        }];
        [_bottomSegmentView setSelectedIndex:self.viewModel.currentIndex animated:NO];
        _bottomSegmentView.layer.masksToBounds = YES;
        _bottomSegmentView.backgroundColor = [UIColor jk_colorWithHexString:@"4D430D"];
    }
    return _bottomSegmentView;
}

- (ZJContentView *)contentView {
    if (!_contentView) {
        CGRect frame = ETScreenB;
        //        frame.size.height -= kNavHeight + 64 + kSafeAreaBottomHeight;
        frame.origin.y += self.viewModel.allProject ? 36 : 0;
        frame.size.height -= kNavHeight + (self.viewModel.allProject ? 39 : 3);
        _contentView = [[ZJContentView alloc] initWithFrame:frame segmentView:(self.viewModel.allProject ? self.topSegmentView : self.bottomSegmentView) parentViewController:self delegate:self];
        _contentView.backgroundColor = ETClearColor;
    }
    return _contentView;
}

- (ETPKProjectPageListView *)projectListView {
    if (!_projectListView) {
        _projectListView = [[ETPKProjectPageListView alloc] initWithViewModel:self.viewModel];
    }
    return _projectListView;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

- (ETPKProjectPageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETPKProjectPageViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -- ZJScrollPageViewDelegate --

- (NSInteger)numberOfChildViewControllers {
    return self.viewModel.titleArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(ETViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    ETViewController<ZJScrollPageViewChildVcDelegate> *childVC = reuseViewController;

    if (!childVC) {
        ETPKProjectViewModel *viewModel = self.viewModel.dataArray[index];
        if ([viewModel.model.ProjectTypeID isEqualToString:@"-1"]) {
            childVC = [[ETPKCustomProjectVC alloc] initWithViewModel:self.viewModel.dataArray[index]];
        } else {
            childVC = [[ETPKProjectVC alloc] initWithViewModel:self.viewModel.dataArray[index]];
        }
    }
    return childVC;
}

// 视图滚动结束
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    if (self.viewModel.allProject) {
        [self.bottomSegmentView setSelectedIndex:index animated:YES];
    } else {
        // 如果不是排行榜页面,进行项目详情页面统计
        [MobClick event:@"ETPKProjectPage" attributes:@{@"ProjectName" : self.viewModel.titleArray[index]}];
    }
    self.viewModel.currentIndex = index;
    self.title = self.viewModel.titleArray[index];
}

/** 为了正常显示子视图必须调用这个方法 */
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
