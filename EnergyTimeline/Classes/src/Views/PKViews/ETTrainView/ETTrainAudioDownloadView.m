//
//  ETTrainAudioDownloadView.m
//  能量圈
//
//  Created by 王斌 on 2018/3/27.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import "ETTrainAudioDownloadView.h"

#import "ETDownLoadManager.h"
#import <SSZipArchive/SSZipArchive.h>

static NSString * const pk_train_exclamation_yellow = @"pk_train_exclamation_yellow";

@interface ETTrainAudioDownloadView ()

@property (nonatomic, strong) UIView *shadowView;

/** 下载内容的提示框 */

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIImageView *projectImageView;

@property (nonatomic, strong) UILabel *projectNameLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *targetTitle;

@property (nonatomic, strong) UILabel *target;

@property (nonatomic, strong) UILabel *groupTitle;

@property (nonatomic, strong) UILabel *group;

@property (nonatomic, strong) UILabel *timeTitle;

@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *downloadProgressLabel;

@property (nonatomic, strong) UIProgressView *downloadProgress;

@property (nonatomic, strong) UILabel *downloadStatus;

@property (nonatomic, strong) UIButton *startDownload;

/** 在WWAN状态下的提醒框 */

@property (nonatomic, strong) UIView *wwanView;

@property (nonatomic, strong) UIImageView *wwanImageView;

@property (nonatomic, strong) UILabel *wwanLabel;

@property (nonatomic, strong) UIButton *endDownload;

@property (nonatomic, strong) UIButton *continueDownload;

/** 没有网络的提醒框 */

@property (nonatomic, strong) UIView *checkView;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic, strong) UILabel *checkLabel;

@end

@implementation ETTrainAudioDownloadView

- (void)updateConstraints {
    WS(weakSelf)
    
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.width.height.equalTo(@60);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(35);
        make.right.equalTo(weakSelf).with.offset(-35);
        make.centerY.equalTo(weakSelf);
        make.height.equalTo(@290);
    }];
    
    [self.projectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.width.height.equalTo(@40);
    }];
    
    [self.projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.projectImageView);
        make.left.equalTo(weakSelf.projectImageView.mas_right).with.offset(10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(@60);
        make.height.equalTo(@1);
    }];
    
    [self.targetTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@35);
        make.top.equalTo(weakSelf.lineView.mas_bottom).with.offset(25);
    }];
    
    [self.target mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-35);
        make.top.equalTo(weakSelf.targetTitle);
    }];
    
    [self.groupTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.targetTitle);
        make.top.equalTo(weakSelf.targetTitle.mas_bottom).with.offset(35);
    }];
    
    [self.group mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.target);
        make.top.equalTo(weakSelf.groupTitle);
    }];
    
    [self.timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.targetTitle);
        make.top.equalTo(weakSelf.groupTitle.mas_bottom).with.offset(35);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.target);
        make.top.equalTo(weakSelf.timeTitle);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
//        make.top.equalTo(weakSelf.timeTitle.mas_bottom).with.offset(25);
        make.height.equalTo(@60);
    }];
    
    [self.downloadProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bottomView);
        make.bottom.equalTo(weakSelf.downloadProgress.mas_top).with.offset(-5);
    }];
    
    [self.downloadProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.bottomView);
        make.left.equalTo(weakSelf.bottomView).with.offset(25);
        make.right.equalTo(weakSelf.bottomView).with.offset(-25);
        make.height.equalTo(@4);
    }];
    
    [self.downloadStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bottomView);
        make.top.equalTo(weakSelf.downloadProgress.mas_bottom).with.offset(5);
    }];
    
    [self.startDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bottomView);
    }];
    
    /** WWAN */
    
    [self.wwanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(-10);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@(170 + kStatusBarHeight));
    }];
    
    [self.wwanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@45);
        make.centerY.equalTo(weakSelf.wwanLabel);
        make.width.height.equalTo(@30);
    }];
    
    [self.wwanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.wwanImageView.mas_right).with.offset(15);
        make.top.equalTo(@(25 + kStatusBarHeight));
        make.right.equalTo(@-40);
    }];
    
    [self.endDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.wwanView.mas_centerX).with.offset(-22);
        make.bottom.equalTo(@-35);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    [self.continueDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.wwanView.mas_centerX).with.offset(22);
        make.bottom.equalTo(@-35);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    /** 检查网络 */
   
    [self.checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(110);
        make.width.equalTo(@185);
        make.height.equalTo(@90);
    }];
    
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.checkView).with.offset(38);
        make.centerY.equalTo(weakSelf.checkView);
//        make.width.height.equalTo(@30);
    }];
    
    [self.checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.checkView.mas_right).with.offset(-38);
        make.centerY.equalTo(weakSelf.checkView);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    if (self = [super initWithFrame:ETScreenB]) {
        self.viewModel = (ETTrainAudioDownloadViewModel *)viewModel;
        [self et_setupViews];
        [self et_bindViewModel];
    }
    return self;
}

- (void)et_setupViews {
    [self addSubview:self.shadowView];
    [self.shadowView addSubview:self.contentView];
    [self.shadowView addSubview:self.backButton];
    [self.contentView addSubview:self.projectImageView];
    [self.contentView addSubview:self.projectNameLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.targetTitle];
    [self.contentView addSubview:self.target];
    [self.contentView addSubview:self.groupTitle];
    [self.contentView addSubview:self.group];
    [self.contentView addSubview:self.timeTitle];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.downloadProgressLabel];
    [self.bottomView addSubview:self.downloadProgress];
    [self.bottomView addSubview:self.downloadStatus];
    [self.bottomView addSubview:self.startDownload];
    
    [self.shadowView addSubview:self.wwanView];
    [self.wwanView addSubview:self.wwanImageView];
    [self.wwanView addSubview:self.wwanLabel];
    [self.wwanView addSubview:self.endDownload];
    [self.wwanView addSubview:self.continueDownload];
    
    [self.shadowView addSubview:self.checkView];
    [self.checkView addSubview:self.checkImageView];
    [self.checkView addSubview:self.checkLabel];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    
    @weakify(self)

    [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.Pro_FilePath]];
    self.projectNameLabel.text = self.viewModel.model.ProjectName;
    self.target.text = [NSString stringWithFormat:@"%ld%@", (long)[self.viewModel.model.TargetNum integerValue], self.viewModel.model.ProjectUnit];
    self.group.text = [NSString stringWithFormat:@"%@组", self.viewModel.model.GroupCount];
    self.time.text = [NSString stringWithFormat:@"%@分钟", self.viewModel.model.NeedsTime];
    
    [self.viewModel.commonFileListCommand execute:nil];
//    [self.viewModel.projectFileListCommand execute:nil];
//    [self.viewModel.projectFileGetCommand execute:nil];
    
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.backSubject sendNext:nil];
        [self removeFromSuperview];
    }];
    
    
    [self.viewModel.refreshSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.projectImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.Pro_FilePath]];
        self.projectNameLabel.text = self.viewModel.model.ProjectName;
        self.target.text = [NSString stringWithFormat:@"%@%@", self.viewModel.model.TargetNum, self.viewModel.model.ProjectUnit];
        self.group.text = [NSString stringWithFormat:@"%@组", self.viewModel.model.GroupCount];
        self.time.text = [NSString stringWithFormat:@"%@分钟", self.viewModel.model.NeedsTime];
    }];
    
    [self.viewModel.startTrainSubject subscribeNext:^(id x) {
        NSLog(@"开始训练~~~~~");
        [self removeFromSuperview];
    }];
    
    [self.viewModel.downloadSubject subscribeNext:^(NSString *link) {
        @strongify(self)
        [[ETDownLoadManager sharedInstance] startDownLoadURL:link progress:^(NSProgress * _Nonnull downloadProgress) {
            // 下载进度
            WS(weakSelf)
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.downloadProgressLabel.text = [NSString stringWithFormat:@"%@/%@", [NSByteCountFormatter stringFromByteCount:downloadProgress.completedUnitCount countStyle:NSByteCountFormatterCountStyleFile], [NSByteCountFormatter stringFromByteCount:downloadProgress.totalUnitCount countStyle:NSByteCountFormatterCountStyleFile]];
                weakSelf.downloadProgress.progress = downloadProgress.fractionCompleted;
            });
        } destination:^(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            // 文件拼接完成后执行,targetPath为临时路径
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *trainAudioPath = [NSString stringWithFormat:@"%@/TrainAudio/", cachesPath];
            BOOL result = [SSZipArchive unzipFileAtPath:[targetPath path] toDestination:trainAudioPath];
            if (result) {
                NSLog(@"成功");
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:[targetPath path] error:nil];
            } else {
                NSLog(@"失败");
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            // 文件下载完毕后调用的方法
            //        WS(weakSelf)
//            if ([self.delegate respondsToSelector:@selector(startTrain)]) {
//                [self.delegate startTrain];
//            }
//            [self removeFromSuperview];
            
            [self.viewModel.startTrainSubject sendNext:nil];
            
        }];
//        [self downloadWithLink:link];
    }];
    
    [self.viewModel.pauseDownloadSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.downloadStatus setText:@"已暂停"];
        [[ETDownLoadManager sharedInstance] pauseDownLoad];
    }];
    
    [self.viewModel.startDownloadSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.downloadStatus setText:@"下载中"];
        [self.startDownload setTitle:@"" forState:UIControlStateNormal];
        [self.startDownload setBackgroundColor:ETClearColor];
        [[ETDownLoadManager sharedInstance] startDownLoad];
    }];
    
    
    [[self.startDownload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [MobClick event:@"ETTrainStartClick"];
        if (!self.viewModel.updateCommonFile && !self.viewModel.updateTrainFile) {
            [self.viewModel.startTrainSubject sendNext:nil];
        } else {
            switch ([[ETDownLoadManager sharedInstance] downLoadState]) {
                case NSURLSessionTaskStateSuspended: {
                    [self.viewModel.startDownloadSubject sendNext:nil];
                }
                    break;
                case NSURLSessionTaskStateRunning: {
                    [self.viewModel.pauseDownloadSubject sendNext:nil];
                }
                    break;
                default:
                    break;
            }
        }
    }];
    
    [[self.endDownload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.startDownload.enabled = YES;
        self.wwanView.hidden = YES;
    }];
    
    [[self.continueDownload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.startDownload.enabled = YES;
        self.wwanView.hidden = YES;
        [self.viewModel.startDownloadSubject sendNext:nil];
    }];

    [[ETDownLoadManager sharedInstance] monitoringState:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知网络");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"未连接网络");
                self.checkView.hidden = NO;
                [self.viewModel.pauseDownloadSubject sendNext:nil];
                self.startDownload.enabled = NO;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"连接蜂窝网络");
                self.wwanView.hidden = NO;
                self.startDownload.enabled = NO;
                if ([[ETDownLoadManager sharedInstance] downLoadState] == NSURLSessionTaskStateRunning) {
                    [self.viewModel.pauseDownloadSubject sendNext:nil];
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"无限网络");
                self.wwanView.hidden = YES;
                self.checkView.hidden = YES;
                self.startDownload.enabled = YES;
            }
                break;
            default:
                break;
        }
    }];
}

- (void)downloadWithLink:(NSString *)link {
    [[ETDownLoadManager sharedInstance] startDownLoadURL:link progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        WS(weakSelf)
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.downloadProgressLabel.text = [NSString stringWithFormat:@"%@/%@", [NSByteCountFormatter stringFromByteCount:downloadProgress.completedUnitCount countStyle:NSByteCountFormatterCountStyleFile], [NSByteCountFormatter stringFromByteCount:downloadProgress.totalUnitCount countStyle:NSByteCountFormatterCountStyleFile]];
            weakSelf.downloadProgress.progress = downloadProgress.fractionCompleted;
        });
    } destination:^(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 文件拼接完成后执行,targetPath为临时路径
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *trainAudioPath = [NSString stringWithFormat:@"%@/TrainAudio/", cachesPath];
        BOOL result = [SSZipArchive unzipFileAtPath:[targetPath path] toDestination:trainAudioPath];
        if (result) {
            NSLog(@"成功");
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:[targetPath path] error:nil];
        } else {
            NSLog(@"失败");
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 文件下载完毕后调用的方法
        //        WS(weakSelf)
        if ([self.delegate respondsToSelector:@selector(startTrain)]) {
            [self.delegate startTrain];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark -- lazyLoad --

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.3];
    }
    return _shadowView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:ETLeftArrow_Gray] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ETWhiteColor;
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

- (UIImageView *)projectImageView {
    if (!_projectImageView) {
        _projectImageView = [[UIImageView alloc] init];
        _projectImageView.layer.cornerRadius = 20;
        _projectImageView.layer.masksToBounds = YES;
    }
    return _projectImageView;
}

- (UILabel *)projectNameLabel {
    if (!_projectNameLabel) {
        _projectNameLabel = [[UILabel alloc] init];
        _projectNameLabel.font = [UIFont systemFontOfSize:12];
        _projectNameLabel.textColor = ETTextColor_Sixth;
    }
    return _projectNameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ETTextColor_Second;
    }
    return _lineView;
}

- (UILabel *)targetTitle {
    if (!_targetTitle) {
        _targetTitle = [[UILabel alloc] init];
        _targetTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _targetTitle.textColor = ETTextColor_Fourth;
        _targetTitle.text = @"数量";
    }
    return _targetTitle;
}

- (UILabel *)target {
    if (!_target) {
        _target = [[UILabel alloc] init];
        _target.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _target.textColor = ETTextColor_Fourth;
        _target.textAlignment = NSTextAlignmentRight;
    }
    return _target;
}

- (UILabel *)groupTitle {
    if (!_groupTitle) {
        _groupTitle = [[UILabel alloc] init];
        _groupTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _groupTitle.textColor = ETTextColor_Fourth;
        _groupTitle.text = @"组数";
    }
    return _groupTitle;
}

- (UILabel *)group {
    if (!_group) {
        _group = [[UILabel alloc] init];
        _group.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _group.textColor = ETTextColor_Fourth;
        _group.textAlignment = NSTextAlignmentRight;
    }
    return _group;
}

- (UILabel *)timeTitle {
    if (!_timeTitle) {
        _timeTitle = [[UILabel alloc] init];
        _timeTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _timeTitle.textColor = ETTextColor_Fourth;
        _timeTitle.text = @"预计时间";
    }
    return _timeTitle;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _time.textColor = ETTextColor_Fourth;
        _time.textAlignment = NSTextAlignmentRight;
    }
    return _time;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = ETMarkYellowColor;
    }
    return _bottomView;
}

- (UILabel *)downloadProgressLabel {
    if (!_downloadProgressLabel) {
        _downloadProgressLabel = [[UILabel alloc] init];
        _downloadProgressLabel.text = @"--/--";
        _downloadProgressLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _downloadProgressLabel.textAlignment = NSTextAlignmentCenter;
        _downloadProgressLabel.textColor = ETTextColor_Fifth;
    }
    return _downloadProgressLabel;
}

- (UIProgressView *)downloadProgress {
    if (!_downloadProgress) {
        _downloadProgress = [[UIProgressView alloc] init];
        _downloadProgress.progressViewStyle = UIProgressViewStyleDefault;
        _downloadProgress.progressTintColor = [ETMarkYellowColor colorWithAlphaComponent:0.6];
        _downloadProgress.trackTintColor = [ETBlackColor colorWithAlphaComponent:0.6];
        _downloadProgress.progress = 0.0;
    }
    return _downloadProgress;
}

- (UILabel *)downloadStatus {
    if (!_downloadStatus) {
        _downloadStatus = [[UILabel alloc] init];
        _downloadStatus.text = @"下载中";
        _downloadStatus.textColor = ETTextColor_Fifth;
        _downloadStatus.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _downloadStatus.textAlignment = NSTextAlignmentCenter;
    }
    return _downloadStatus;
}

- (UIButton *)startDownload {
    if (!_startDownload) {
        _startDownload = [[UIButton alloc] init];
        _startDownload.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        [_startDownload setTitle:@"开始训练" forState:UIControlStateNormal];
        [_startDownload setTitleColor:ETTextColor_Fifth forState:UIControlStateNormal];
        _startDownload.backgroundColor = ETMarkYellowColor;
    }
    return _startDownload;
}

/** WWAN */

- (UIView *)wwanView {
    if (!_wwanView) {
        _wwanView = [[UIView alloc] init];
        _wwanView.backgroundColor = [ETWhiteColor colorWithAlphaComponent:0.8];
        _wwanView.layer.cornerRadius = 10;
        _wwanView.hidden = YES;
    }
    return _wwanView;
}

- (UIImageView *)wwanImageView {
    if (!_wwanImageView) {
        _wwanImageView = [[UIImageView alloc] init];
        [_wwanImageView setImage:[UIImage imageNamed:pk_train_exclamation_yellow]];
    }
    return _wwanImageView;
}

- (UILabel *)wwanLabel {
    if (!_wwanLabel) {
        _wwanLabel = [[UILabel alloc] init];
        _wwanLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _wwanLabel.textColor = ETTextColor_Fifth;
        _wwanLabel.numberOfLines = 0;
        _wwanLabel.text = @"当前未在Wi-Fi状态下，下载将消耗流量，建议连接Wi-Fi后下载。";
    }
    return _wwanLabel;
}

- (UIButton *)endDownload {
    if (!_endDownload) {
        _endDownload = [[UIButton alloc] init];
        _endDownload.layer.cornerRadius = 10;
        _endDownload.backgroundColor = ETTextColor_Second;
        [_endDownload setTitle:@"结束下载" forState:UIControlStateNormal];
        [_endDownload setTitleColor:ETTextColor_Fourth forState:UIControlStateNormal];
        _endDownload.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _endDownload;
}

- (UIButton *)continueDownload {
    if (!_continueDownload) {
        _continueDownload = [[UIButton alloc] init];
        _continueDownload.layer.cornerRadius = 10;
        _continueDownload.backgroundColor = ETMinorColor;
        [_continueDownload setTitle:@"继续下载" forState:UIControlStateNormal];
        [_continueDownload setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        _continueDownload.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    }
    return _continueDownload;
}

/** 检查网络 */

- (UIView *)checkView {
    if (!_checkView) {
        _checkView = [[UIView alloc] init];
        _checkView.backgroundColor = [ETWhiteColor colorWithAlphaComponent:0.8];
        _checkView.layer.cornerRadius = 10;
        _checkView.hidden = YES;
    }
    return _checkView;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] init];
        [_checkImageView setImage:[UIImage imageNamed:pk_train_exclamation_yellow]];
    }
    return _checkImageView;
}

- (UILabel *)checkLabel {
    if (!_checkLabel) {
        _checkLabel = [[UILabel alloc] init];
        _checkLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _checkLabel.textColor = ETTextColor_Fifth;
        _checkLabel.text = @"请检查网络";
    }
    return _checkLabel;
}

- (ETTrainAudioDownloadViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETTrainAudioDownloadViewModel alloc] init];
    }
    return _viewModel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
