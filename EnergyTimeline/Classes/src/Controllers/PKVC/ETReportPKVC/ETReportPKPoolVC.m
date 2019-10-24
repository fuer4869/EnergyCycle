//
//  ETReportPKPoolVC.m
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKPoolVC.h"
#import "ETReportPKPoolView.h"
#import "ETReportPKPoolViewModel.h"

#import "ECPickerController.h"

#import "ETShareView.h"
#import "ShareSDKManager.h"

#import "ETRewardView.h"

@interface ETReportPKPoolVC () <ECPickerControllerDelegate, ETShareViewDelegate>

@property (nonatomic, strong) ETReportPKPoolView *mainView;

@property (nonatomic, strong) ETReportPKPoolViewModel *viewModel;

@property (nonatomic, strong) ECPickerController *picker;

@end

@implementation ETReportPKPoolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ETMainBgColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    
    @weakify(self)

    [[self.viewModel.pickerSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.picker.imageIDArr setArray:self.viewModel.imageIDArray];
//        self.picker.imageIDArr = self.viewModel.imageIDArray;
        self.picker.imageMaxCount = 9 - self.viewModel.todayImageIDArray.count;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    
    [[self.viewModel.dismissSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id responseObject) {
        @strongify(self)
//        [self showShareView];
        [[self.viewModel.rankingNumCommand execute:nil] subscribeNext:^(id title) {
            self.viewModel.shareTitle = title[@"Data"];
            [ETShareView shareViewWithFullScreenWithDelegate:self];
        }];
        if ([responseObject[@"Data"] integerValue] > 0) {
            [ETRewardView rewardViewWithContent:[NSString stringWithFormat:@"%@积分", responseObject[@"Data"]] duration:2.0 audioType:ETAudioTypeReportPKPool];
        }
    }];
    
}

- (void)et_layoutNavigation {
    [MobClick beginLogPageView:@"ETReportPKPoolVC"];
    self.title = @"今天已打卡";
    [self setupLeftNavBarWithimage:ETGrayBack];
}

- (void)leftAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)et_willDisappear {
    [MobClick endLogPageView:@"ETReportPKPoolVC"];
    [self resetNavigation];
}

- (void)showShareView {
    [ETShareView shareViewWithBottomWithDelegate:self];
}

#pragma mark -- lazyLoad --

- (ETReportPKPoolView *)mainView {
    if (!_mainView) {
        _mainView = [[ETReportPKPoolView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETReportPKPoolViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETReportPKPoolViewModel alloc] init];
    }
    return _viewModel;
}

- (ECPickerController *)picker {
    if (!_picker) {
        _picker = [[ECPickerController alloc] init];
//        _picker.imageMaxCount = 9;
//        _picker.imageIDArr = self.viewModel.imageIDArray;
        _picker.pickerDelegate = self;
    }
    return _picker;
}

#pragma mark -- delegate --

- (void)exportImageData:(NSArray *)imageData ID:(NSArray *)ID {
    [self.viewModel.selectImgArray removeAllObjects];
    [self.viewModel.imageIDArray removeAllObjects];
    [self.viewModel.selectImgArray addObjectsFromArray:self.viewModel.todaySelectImgArray];
    [self.viewModel.imageIDArray addObjectsFromArray:self.viewModel.todayImageIDArray];
    [self.viewModel.selectImgArray addObjectsFromArray:imageData];
    [self.viewModel.imageIDArray addObjectsFromArray:ID];
    [self.viewModel.refreshEndSubject sendNext:nil];
}

#pragma mark -- shareDelegate --

- (void)shareViewClose {
    [self leftAction];
}

- (ETShareModel *)shareModel {
    ETShareModel *shareModel = [[ETShareModel alloc] init];
    shareModel.title = self.viewModel.shareTitle;
    shareModel.imageArray = nil;
    shareModel.shareUrl = [NSString stringWithFormat:@"%@%@?UserID=%@&date=%@", INTERFACE_URL, HTML_PKPersonReport, User_ID, [[NSDate date] jk_stringWithFormat:[NSDate jk_ymdFormat]]];
    
    return shareModel;
}

/** QQ分享 */
- (void)shareViewClickQQBtn {
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformTypeQQ shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** QQ空间分享 */
- (void)shareViewClickQzoneBtn {
    NSLog(@"qzone");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeQZone shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 微信分享 */
- (void)shareViewClickWechatSessionBtn {
    NSLog(@"wechat");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatSession shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 微博分享 */
- (void)shareViewClickSinaWeiboBtn {
    NSLog(@"sina");
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformTypeSinaWeibo shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

/** 朋友圈分享 */
- (void)shareViewClickWechatTimelineBtn {
    [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatTimeline shareModel:[self shareModel] webImage:nil result:^(SSDKResponseState state) {
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
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
