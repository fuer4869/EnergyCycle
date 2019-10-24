//
//  ETDailyPKPageVC.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKPageVC.h"
#import "ETDailyPKPageViewModel.h"
#import "ZJScrollPageView.h"
#import "ETDailyPKPageListView.h"

#import "ETDailyPKVC.h"

#import "ETReportPKVC.h"
#import "ETReportPKNavController.h"

/** 图片压缩 */
#import "UIImage+Compression.h"

@interface ETDailyPKPageVC () <ZJScrollPageViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) ZJSegmentStyle *style;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@property (nonatomic, strong) ETDailyPKPageViewModel *viewModel;

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) ETDailyPKPageListView *pageListView;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation ETDailyPKPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)et_getNewData {
    [[self.viewModel.projectListCommand execute:nil] subscribeNext:^(id responseObject) {
        if ([responseObject[@"Status"] integerValue] == 200) {
            [self.view addSubview:self.bgImage];
            [self.view addSubview:self.scrollPageView];
            if (self.projectName) {
                for (int i = 0; i < self.viewModel.titleArray.count; i ++) {
                    if ([self.viewModel.titleArray[i] isEqualToString:self.projectName]) {
                        [self.scrollPageView setSelectedIndex:i animated:NO];
                        break;
                    }
                }

//                [self.viewModel.titleArray valueForKeyPath:self.projectName];
//                [self.scrollPageView setSelectedIndex:2 animated:YES];
            }
        }
    }];
}

//- (void)updateViewConstraints {
//    WS(weakSelf)
//    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.view);
//    }];
//
//    [super updateViewConstraints];
//}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETDailyPKPageVC"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)et_bindViewModel {
    @weakify(self)
    
    
    [[self.viewModel.pageViewCellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self.scrollPageView setSelectedIndex:indexPath.row animated:YES];
    }];
    
    [[self.viewModel.popSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.viewModel.removePageViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:2
                            options:UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             @strongify(self)
                             self.pageListView.alpha = 0;
                             self.scrollPageView.segmentView.alpha = 1;
                         } completion:^(BOOL finished) {
                             @strongify(self)
                             [self.pageListView removeFromSuperview];
                             self.pageListView = nil;
                         }];
    }];
    
    [[self.viewModel.submitSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETReportPKVCEnterClick"];
        ETReportPKVC *reportPKVC = [[ETReportPKVC alloc] init];
        ETReportPKNavController *reportPKNavC = [[ETReportPKNavController alloc] initWithRootViewController:reportPKVC];
        reportPKNavC.interactivePopGestureRecognizer.delegate = self;
        [self presentViewController:reportPKNavC animated:YES completion:nil];
    }];
    
    [[self.viewModel.setupSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self selectPhotos];
    }];
    
    [[self.viewModel.refreshSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString *img) {
        @strongify(self)
        [self.bgImage sd_setImageWithURL:[NSURL URLWithString:img]];
    }];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETDailyPKPageVC"];
    [self resetNavigation];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -- lazyLoad --

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.frame = ETScreenB;
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
        _bgImage.layer.masksToBounds = YES;
        [_bgImage setImage:[UIImage imageNamed:ETUserPKCoverImg_Default]];
    }
    return _bgImage;
}

- (ZJSegmentStyle *)style {
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
        _style.showLine = YES;
        _style.showLeftExtraButton = YES;
        _style.showExtraButton = YES;
        _style.scrollLineHeight = 1;
        _style.scrollLineColor = ETMarkYellowColor;
        _style.titleFont = [UIFont systemFontOfSize:12];
        _style.normalTitleColor = ETWhiteColor;
        _style.selectedTitleColor = ETWhiteColor;
        _style.leftExtraBtnBackgroundImageName = ETWhiteBack;
        _style.extraBtnBackgroundImageName = @"more_white";
    }
    return _style;
}

- (ZJScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0.0, kStatusBarHeight, ETScreenW, ETScreenH - kStatusBarHeight) segmentStyle:self.style titles:self.viewModel.titleArray parentViewController:self delegate:self];
        _scrollPageView.backgroundColor = [UIColor clearColor];
        _scrollPageView.contentView.backgroundColor = [UIColor clearColor];
        _scrollPageView.contentView.collectionView.backgroundColor = [UIColor clearColor];
        _scrollPageView.segmentView.backgroundColor = [UIColor clearColor];
        
        WS(weakSelf)
        _scrollPageView.leftExtraBtnOnClick = ^(UIButton *leftExtraBtn) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn) {
            [weakSelf.view addSubview:weakSelf.pageListView];
            weakSelf.scrollPageView.segmentView.alpha = 0;
            [weakSelf updateViewConstraints];
        };
    }
    return _scrollPageView;
}

- (ETDailyPKPageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETDailyPKPageViewModel alloc] init];
    }
    return _viewModel;
}

- (ETDailyPKPageListView *)pageListView {
    if (!_pageListView) {
        _pageListView = [[ETDailyPKPageListView alloc] initWithViewModel:self.viewModel];
        _pageListView.frame = ETScreenB;
    }
    return _pageListView;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

#pragma mark -- private --

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

#pragma mark -- delegate --

- (NSInteger)numberOfChildViewControllers {
    return self.viewModel.dataArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(ETDailyPKVC<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    self.viewModel.currentIndex = index;
    ETDailyPKVC<ZJScrollPageViewChildVcDelegate> *childVC = reuseViewController;
    childVC.view.backgroundColor = [UIColor clearColor];
    if (!childVC) {
        childVC = [[ETDailyPKVC alloc] initWithViewModel:self.viewModel.dataArray[index]];
    }
    
    return childVC;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(ETDailyPKVC *)childViewController forIndex:(NSInteger)index {
    NSDictionary *dic = @{@"ProjectName" : self.viewModel.titleArray[index]};
    [MobClick event:@"ETDailyPKPageVCClick" attributes:dic];
    if (childViewController.viewModel.headerViewModel.model && childViewController.viewModel.headerViewModel.model.PKCoverImg) {
        [self.bgImage sd_setImageWithURL:[NSURL URLWithString:childViewController.viewModel.headerViewModel.model.PKCoverImg]];
    } else {
        [self.bgImage setImage:[UIImage imageNamed:ETUserPKCoverImg_Default]];
    }
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
