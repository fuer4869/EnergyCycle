//
//  ETTrainVC.m
//  能量圈
//
//  Created by 王斌 on 2018/3/9.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainVC.h"
#import "ETTrainView.h"

#import "ETTrainTargetVC.h"

#import "ETTrainCompleteVC.h"

/** 下载管理类 */
#import "ETDownLoadManager.h"

/** 训练音频播放管理器 */
#import "ETTrainAudioManager.h"

@interface ETTrainVC ()

@property (nonatomic, strong) ETTrainView *mainView;


@property (nonatomic, strong) UIButton *close;

@property (weak, nonatomic) IBOutlet UILabel *left;
@property (weak, nonatomic) IBOutlet UILabel *right;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *stop;

@end

@implementation ETTrainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
////    [[ETDownLoadManager sharedInstance] startDownLoadURL:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
//    [[ETDownLoadManager sharedInstance] startDownLoadURL:@"http://172.16.0.111/Uploads/voices.zip"
//                                                progress:^(NSProgress * _Nonnull downloadProgress) {
//                                                    //
//                                                    WS(weakSelf)
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
////                                                        weakSelf.left.text = [NSString stringWithFormat:@"%qi", downloadProgress.completedUnitCount];
////                                                        weakSelf.right.text = [NSString stringWithFormat:@"%qi", downloadProgress.totalUnitCount];
//                                                        weakSelf.left.text = [NSByteCountFormatter stringFromByteCount:downloadProgress.completedUnitCount countStyle:NSByteCountFormatterCountStyleFile];
//                                                        weakSelf.right.text = [NSByteCountFormatter stringFromByteCount:downloadProgress.totalUnitCount countStyle:NSByteCountFormatterCountStyleFile];
//
//                                                    });
//
//                                                } destination:^(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//                                                    //
//                                                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                                                    //
//                                                }];
////    [[ETTrainAudioManager sharedInstance] backgroundPlayWithAudio:ETTrainBackgroundAudioFirst];
//    [[ETTrainAudioManager sharedInstance] startPlay];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)updateViewConstraints {
    WS(weakSelf)
//    [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(weakSelf.view);
//        make.height.equalTo(@100);
//    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
//        make.top.equalTo(weakSelf.close.mas_bottom);
//        make.left.right.bottom.equalTo(weakSelf.view);

    }];
    
    [super updateViewConstraints];
}

- (void)et_addSubviews {
//    [self.view addSubview:self.close];
    [self.view addSubview:self.mainView];
}

- (void)et_bindViewModel {
    @weakify(self)
    
//    [self.viewModel.setupSubject subscribeNext:^(id x) {
//        @strongify(self)
//        ETTrainTargetVC *targetVC = [[ETTrainTargetVC alloc] init];
//        [self presentViewController:targetVC animated:YES completion:nil];
//    }];
    
    [self.viewModel.backSubject subscribeNext:^(id x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.viewModel.trainEndCommand.executionSignals.switchToLatest subscribeNext:^(id responseObject) {
        @strongify(self)
        if ([responseObject[@"Status"] integerValue] == 200) {
            NSLog(@"%@", responseObject);
            NSLog(@"%@", self.presentingViewController);
            
            [[ETTrainAudioManager sharedInstance] trainEnd];
            
            UIViewController *presnetingVC = self;
            while (presnetingVC.presentingViewController) {
                presnetingVC = presnetingVC.presentingViewController;
            }
            [presnetingVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
  
    [self.viewModel.trainFinishSubject subscribeNext:^(id x) {
        @strongify(self)
        
        [[ETTrainAudioManager sharedInstance] bgmPause];
        
        ETTrainCompleteVC *trainCompleteVC = [[ETTrainCompleteVC alloc] initWithViewModel:self.viewModel];
        [self presentViewController:trainCompleteVC animated:YES completion:nil];
        
//        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

#pragma mark -- lazyLoad --

- (UIButton *)close {
    if (!_close) {
        _close = [[UIButton alloc] init];
        @weakify(self)
        [[_close rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            ETTrainTargetVC *targetVC = [[ETTrainTargetVC alloc] init];
//            [self.navigationController pushViewController:targetVC animated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:targetVC animated:YES completion:nil];
        }];
    }
    return _close;
}

- (ETTrainView *)mainView {
    if (!_mainView) {
        _mainView = [[ETTrainView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

- (ETTrainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainViewModel alloc] init];
    }
    return _viewModel;
}

- (IBAction)startOrpause:(id)sender {
    self.start.selected = !self.start.isSelected;
    
    if (self.start.selected) {
        [[ETDownLoadManager sharedInstance] startDownLoad];
//        [[ETTrainAudioManager sharedInstance] backgroundPlay];
        [[ETTrainAudioManager sharedInstance] trainPlay];
        [self.start setTitle:@"暂停" forState:UIControlStateNormal];
    } else {
        [[ETDownLoadManager sharedInstance] pauseDownLoad];
//        [[ETTrainAudioManager sharedInstance] backgroundPause];
        [[ETTrainAudioManager sharedInstance] trainPause];
        [self.start setTitle:@"继续" forState:UIControlStateNormal];
    }
    
//    [[ETDownLoadManager sharedInstance] ]
}

- (IBAction)stop:(id)sender {
    [[ETDownLoadManager sharedInstance] stopDownLoad];
    NSLog(@"停止");
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
