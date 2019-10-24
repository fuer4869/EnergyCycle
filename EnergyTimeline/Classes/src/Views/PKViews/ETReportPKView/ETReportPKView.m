//
//  ETReportPKView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKView.h"
#import "ETReportPKViewModel.h"
#import "ETPhotoCollectionViewCell.h"

#import "ETReportPKTableViewCell.h"
#import "ETSyncPostTableViewCell.h"
#import "ETShareTableViewCell.h"

#import "ETRewardView.h"

#import "ShareSDKManager.h"

#import "ETHealthManager.h"

static NSString * const camera = @"camera_gray";
static NSString * const postContentTextColor = @"95A9AB";
static NSString * const postViewColor = @"EEEEEE";

@interface ETReportPKView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITextViewDelegate, ETPhotoCollectionViewCellDelegate> {
    BOOL onTimeline;
    BOOL onWechat;
    BOOL onWeibo;
    BOOL onQQ;
    BOOL onQzone;
}

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *postView;

@property (nonatomic, strong) UITextView *postContentTextView;

@property (nonatomic, strong) UIButton *pictureButton;

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIButton *projectButton;

@property (nonatomic, strong) UITextField *numberTextField;

@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, strong) UIButton *healthButton;

@property (nonatomic, strong) UIButton *reportButton;

@property (nonatomic, strong) UITableView *projectTableView;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UIImageView *remindPicture;

@property (nonatomic, strong) ETReportPKViewModel *viewModel;

@end

@implementation ETReportPKView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETReportPKViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(weakSelf);
//        make.height.equalTo(@300);
//    }];

//    self.mainTableView.tableHeaderView = self.headerView;
//    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(weakSelf.headerView);
//    }];
    
//    CGFloat projectTableViewHeight = self.viewModel.selectProjectArray.count * 60 + 30;
    CGFloat projectTableViewHeight = self.viewModel.selectProjectArray.count * 90 + 15;

    [self.projectTableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@64);
//        make.top.left.right.equalTo(weakSelf.headerView);
        make.top.left.right.equalTo(weakSelf.headerView);
//        make.top.equalTo(weakSelf.headerView).with.offset(15);
        make.height.equalTo(@(projectTableViewHeight));
    }];
    
    [self.projectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.headerView);
//        make.centerY.equalTo(weakSelf.headerView);
//        make.height.width.equalTo(@(ETScreenW * 0.5));
        make.top.equalTo(weakSelf.projectTableView.mas_bottom).with.equalTo(90);
//        make.bottom.equalTo(weakSelf.postView.mas_top).with.offset(-30);
        make.height.width.equalTo(@50);
    }];
    
    CGFloat textViewHeight =  [self.postContentTextView sizeThatFits:CGSizeMake(self.postContentTextView.frame.size.width, MAXFLOAT)].height;
    CGFloat postViewHeight = textViewHeight > 34 ? (textViewHeight > 51 ? 84 : 67) : 50;
    postViewHeight = self.viewModel.selectImgArray.count ? 84 : postViewHeight;
    
    [self.postView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerView).with.offset(30);
        make.right.equalTo(weakSelf.headerView).with.offset(-30);
        make.bottom.equalTo(weakSelf.reportButton.mas_top).with.offset(-30);
        make.height.equalTo(@(postViewHeight));
    }];
    
    [self.postContentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.postView).with.offset(15);
        make.right.equalTo(weakSelf.postView).with.offset(-64);
//        make.centerY.equalTo(weakSelf.postView);
//        make.top.bottom.equalTo(weakSelf.postView);
        make.top.equalTo(weakSelf.postView).with.offset(13);
        make.bottom.equalTo(weakSelf.postView).with.offset(-13);
    }];
        
    [self.pictureButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.postView).with.offset(-4);
        make.width.equalTo(@60);
        if (self.viewModel.selectImgArray.count) {
            make.height.equalTo(@60);
        }
        make.top.equalTo(weakSelf.postView).with.offset(10);
        make.bottom.equalTo(weakSelf.postView).with.offset(-10);
    }];
    
    [self.remindPicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.headerView).with.offset(-15);
        make.bottom.equalTo(weakSelf.postView.mas_top).with.offset(-3);
//        make.height.equalTo(@45);
//        make.width.equalTo(@125);
    }];
    
//    [self.projectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right
//    }];
    
//    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.right.equalTo(weakSelf.headerView.mas_centerX).with.offset(10);
//        make.centerX.equalTo(weakSelf.headerView).with.offset(-10);
//        make.top.equalTo(weakSelf.projectButton.mas_bottom).with.offset(50);
//        make.width.equalTo(@115);
//    }];
//    
//    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.numberTextField.mas_right);
//        make.centerY.equalTo(weakSelf.numberTextField);
//    }];
//    
//    [self.healthButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.unitLabel.mas_bottom).with.offset(5);
//        make.centerX.equalTo(weakSelf.bgImage);
//    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.bgImage.mas_bottom).with.offset(35);
        make.left.equalTo(weakSelf.headerView).with.offset(30);
        make.right.equalTo(weakSelf.headerView).with.offset(-30);
        make.bottom.equalTo(weakSelf.headerView).with.offset(IsiPhoneX ? -(30.f + 34.f) : -30.f);
//        make.centerX.equalTo(weakSelf.headerView);
        make.height.equalTo(@50);
    }];
    
    CGFloat collectionViewHeight = (50 + 10 + 50 * (self.viewModel.imageIDArray.count + 1)) > ETScreenW ? 120 : 60;
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.reportButton.mas_bottom).with.offset(@30);
        make.bottom.equalTo(weakSelf.headerView.mas_bottom);
        make.left.equalTo(weakSelf.headerView).with.offset(25);
        make.right.equalTo(weakSelf.headerView).with.offset(-25);
        make.height.equalTo(@(collectionViewHeight));
    }];
    
//    self.headerView.jk_height = projectTableViewHeight + 80 + 90 + collectionViewHeight + 25;
    CGFloat headerTotalHeight = projectTableViewHeight + 230 + postViewHeight + 30 + 50 + (IsiPhoneX ? (30.f + 34.f) : 30);
    self.headerView.jk_height = headerTotalHeight < ETScreenH - kNavHeight ? ETScreenH - kNavHeight : headerTotalHeight;
    [self.mainTableView setTableHeaderView:self.headerView];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
//    [self.headerView addSubview:self.bgImage];
    [self.headerView addSubview:self.projectTableView];
    [self.headerView addSubview:self.projectButton];
//    [self.headerView addSubview:self.numberTextField];
//    [self.headerView addSubview:self.unitLabel];
//    [self.headerView addSubview:self.healthButton];
    [self addSubview:self.remindPicture];
    [self addSubview:self.postView];
    [self.postView addSubview:self.postContentTextView];
    [self.postView addSubview:self.pictureButton];
    
    [self.headerView addSubview:self.reportButton];
    [self.headerView addSubview:self.collectionView];

    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

}

- (void)et_bindViewModel {
//    RAC(self.viewModel, reportNum) = self.numberTextField.rac_textSignal;
    [self.viewModel.firstEnterDataCommand execute:nil];

    @weakify(self)
    
    [[ETHealthManager sharedInstance] stepAutomaticUpload];
    
    [self.viewModel.textFieldSubject subscribeNext:^(NSMutableDictionary *dic) {
        @strongify(self)
        BOOL exist = NO;
        BOOL lack = NO;
        for (NSMutableDictionary *dataDic in self.viewModel.projectNumArray) {
            if ([dic[@"ProjectID"] isEqualToString:dataDic[@"ProjectID"]]) {
                exist = YES;
                [dataDic setDictionary:dic];
            }
            if ([dataDic[@"ReportNum"] isEqualToString:@""]) {
                lack = YES;
            }
        }
        if (!exist) {
            [self.viewModel.projectNumArray addObject:dic];
            lack = [dic[@"ReportNum"] isEqualToString:@""];
        }
        if (self.viewModel.projectNumArray.count == self.viewModel.selectProjectArray.count && !lack) {
            [self textFieldEnabled];
        } else {
            [self textFieldDisable];
        }
    }];
    
    [self.viewModel.firstEnterEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (![self.viewModel.firstEnterModel.Is_FirstPK_Pic boolValue]) {
            self.remindPicture.hidden = NO;
        }
    }];
    
    [[self.viewModel.syncPostViewModel.syncSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *sync) {
        @strongify(self)
        self.viewModel.onSync = [sync boolValue];
    }];
    
    [[self.viewModel.shareViewModel.timelineSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *timeline) {
        onTimeline = [timeline boolValue];
    }];
    
    [[self.viewModel.shareViewModel.wechatSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *wechat) {
        onWechat = [wechat boolValue];
    }];
    
    [[self.viewModel.shareViewModel.weiboSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *weibo) {
        onWeibo = [weibo boolValue];
    }];
    
    [[self.viewModel.shareViewModel.qqSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *qq) {
        onQQ = [qq boolValue];
    }];
    
    [[self.viewModel.shareViewModel.qzoneSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *qzone) {
        onQzone = [qzone boolValue];
    }];
    
    [[self.viewModel.reloadSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.projectTableView reloadData];
        [self.mainTableView reloadData];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
//        if (self.viewModel.projectModel.ProjectID) {
//            self.viewModel.reportNum = @"";
//            self.numberTextField.text = @"";
//            self.numberTextField.hidden = NO;
//            self.unitLabel.hidden = NO;
//            self.unitLabel.text = self.viewModel.projectModel.ProjectUnit;
//            if ([self.viewModel.projectModel.ProjectName isEqualToString:@"健康走"]) {
//                self.numberTextField.userInteractionEnabled = NO;
////                self.healthButton.hidden = NO;
//                ETHealthManager *manager = [ETHealthManager sharedInstance];
//                [manager authorizeHealthKit:^(BOOL success, NSError *error) {
//                    if (success) {
//                        @strongify(self)
//                        [manager getStepCount:^(double value, NSError *error) {
//                            @strongify(self)
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                self.numberTextField.text = [NSString stringWithFormat:@"%.f", value];
//                                self.viewModel.reportNum = self.numberTextField.text;
//                                if (value) {
//                                    [self textFieldEnabled];
//                                } else {
//                                    [self textFieldDisable];
//                                }
//                            });
//                        }];
//                    }
//                }];
//            } else {
//                self.numberTextField.userInteractionEnabled = YES;
//                self.healthButton.hidden = YES;
//            }
//            if ([self.viewModel.projectModel.ProjectUnit isEqualToString:@"天"]) {
//                [self textFieldEnabled];
//                self.viewModel.reportNum = @"1";
//                self.numberTextField.hidden = YES;
//                self.unitLabel.hidden = YES;
//            }
//            if ([self.viewModel.projectModel.ProjectUnit isEqualToString:@"公里"]) {
//                self.numberTextField.keyboardType = UIKeyboardTypeDecimalPad;
//            } else {
//                self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
//            }
//            [self.projectButton sd_setImageWithURL:[NSURL URLWithString:self.viewModel.projectModel.FilePath] forState:UIControlStateNormal];
//        } else {
//            [self textFieldDisable];
//            self.numberTextField.text = @"";
//            self.numberTextField.hidden = YES;
//            self.unitLabel.hidden = YES;
//            self.reportButton.enabled = NO;
//            [self.projectButton setImage:[UIImage imageNamed:@"plus_red"] forState:UIControlStateNormal];
//        }
    }];
    
    [[self.viewModel.reloadCollectionViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        CGFloat collectionViewHeight = (50 + 10 + 50 * (self.viewModel.imageIDArray.count + 1)) > ETScreenW ? 120 : 60;
        self.headerView.frame = CGRectMake(0, 0, ETScreenW, 515 + collectionViewHeight);
        self.mainTableView.tableHeaderView = self.headerView;
        if (self.viewModel.selectImgArray.count) {
            [self.pictureButton setImage:self.viewModel.selectImgArray[0] forState:UIControlStateNormal];
        } else {
            [self.pictureButton setImage:[UIImage imageNamed:camera] forState:UIControlStateNormal];
        }
        [self.mainTableView reloadData];
        [self.collectionView reloadData];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }];
    
    [[self.healthButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        ETHealthManager *manager = [ETHealthManager sharedInstance];
        [manager authorizeHealthKit:^(BOOL success, NSError *error) {
            if (success) {
                @strongify(self)
                [manager getStepCount:^(double value, NSError *error) {
                    @strongify(self)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.numberTextField.text = [NSString stringWithFormat:@"%.f", value];
                        self.viewModel.reportNum = self.numberTextField.text;
                        if (value) {
                            [self textFieldEnabled];
                        } else {
                            [self textFieldDisable];
                        }
                    });
                }];
            }
        }];
    }];
    
    [[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.reportCommand execute:nil];
    }];
    
    [[self.viewModel.shareSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id responseObject) {
        @strongify(self)
        ETShareModel *shareModel = [[ETShareModel alloc] init];
        NSString *title = [NSString stringWithFormat:@"我今天"];
        for (ETPKProjectModel *projectModel in self.viewModel.selectProjectArray) {
            for (NSMutableDictionary *dic in self.viewModel.projectNumArray) {
                if ([dic[@"ProjectID"] isEqualToString:projectModel.ProjectID]) {
                    title = [title stringByAppendingString:[NSString stringWithFormat:@"%@%@%@，", projectModel.ProjectName, dic[@"ReportNum"], projectModel.ProjectUnit]];
                }
            }
        }
        title = [title stringByAppendingString:@"加入能量圈，和我一起PK吧！"];
//        shareModel.title = [NSString stringWithFormat:@"我今天%@%@%@，加入能量圈，和我一起PK吧！", self.viewModel.projectModel.ProjectName, self.viewModel.reportNum, self.viewModel.projectModel.ProjectUnit];
        shareModel.title = title;
        shareModel.content = @"快来和我一起PK吧!";
        
        NSArray *arr = [responseObject[@"Data"] componentsSeparatedByString:@"*"];
        
        shareModel.shareUrl = [NSString stringWithFormat:@"%@%@?ReportID=%@", INTERFACE_URL, HTML_PKDetail, arr[0]];
        
        NSLog(@"%@", shareModel.shareUrl);
        if (onTimeline) {
            [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatTimeline shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                @strongify(self)
                if (state == SSDKResponseStateSuccess || state == SSDKResponseStateCancel) {
                    onTimeline = NO;
                    [self.viewModel.shareSubject sendNext:responseObject];
                }
            }];
        } else if (onWechat) {
            [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeWechatSession shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                @strongify(self)
                if (state == SSDKResponseStateSuccess || state == SSDKResponseStateCancel) {
                    onWechat = NO;
                    [self.viewModel.shareSubject sendNext:responseObject];
                }
            }];
        } else if (onWeibo) {
            [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformTypeSinaWeibo shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                @strongify(self)
                if (state == SSDKResponseStateSuccess || state == SSDKResponseStateCancel) {
                    onWeibo = NO;
                    [self.viewModel.shareSubject sendNext:responseObject];
                }
            }];
        } else if (onQQ) {
            [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeQQFriend shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                @strongify(self)
                if (state == SSDKResponseStateSuccess || state == SSDKResponseStateCancel) {
                    onQQ = NO;
                    [self.viewModel.shareSubject sendNext:responseObject];
                }
            }];
        } else if (onQzone) {
            [[ShareSDKManager shareInstance] shareWithShareType:SSDKPlatformSubTypeQZone shareModel:shareModel webImage:nil result:^(SSDKResponseState state) {
                @strongify(self)
                if (state == SSDKResponseStateSuccess || state == SSDKResponseStateCancel) {
                    onQzone = NO;
                    [self.viewModel.shareSubject sendNext:responseObject];
                }
            }];
        } else if (![arr[1] isEqualToString:@"0"]) {
//            [ETRewardView rewardViewWithContent:[NSString stringWithFormat:@"+%@积分", arr[1]] duration:2.0 audioType:ETAudioTypeReportPK];
            NSString *content = [NSString stringWithFormat:@"%@积分", responseObject[@"Data"][@"Integral"]];
            NSString *extra = [NSString stringWithFormat:@"恭喜你，额外获得了%@积分", responseObject[@"Data"][@"RewardIntegral"]];
            if ([responseObject[@"Data"][@"RewardIntegral"] integerValue]) {
                [ETRewardView rewardViewWithContent:content extra:extra duration:2.0 audioType:ETAudioTypeReportPK];
            } else {
                [ETRewardView rewardViewWithContent:content duration:2.0 audioType:ETAudioTypeReportPK];
            }
        }
    }];
}

- (void)didLongpressedPhoto:(NSInteger)index {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确认要删除该图片吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
}

- (void)textFieldDisable {
    self.reportButton.enabled = NO;
    self.reportButton.backgroundColor = ETClearColor;
    [self.reportButton setTitleColor:ETMinorColor forState:UIControlStateNormal];
}

- (void)textFieldEnabled {
    self.reportButton.enabled = YES;
    self.reportButton.backgroundColor = ETMinorColor;
    [self.reportButton setTitleColor:ETWhiteColor forState:UIControlStateNormal];
}

#pragma mark -- lazyLoad --

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, ETScreenW, ETScreenH - kNavHeight);
    }
    return _headerView;
}

- (UIView *)postView {
    if (!_postView) {
        _postView = [[UIView alloc] init];
        _postView.backgroundColor = ETMinorBgColor;
        _postView.layer.cornerRadius = 25;
        _postView.layer.masksToBounds = YES;
    }
    return _postView;
}

- (UITextView *)postContentTextView {
    if (!_postContentTextView) {
        _postContentTextView = [[UITextView alloc] init];
        _postContentTextView.delegate = self;
        _postContentTextView.bounces = NO;
        _postContentTextView.backgroundColor = ETClearColor;
        _postContentTextView.showsVerticalScrollIndicator = NO;
        _postContentTextView.showsHorizontalScrollIndicator = NO;
        _postContentTextView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
//        _postContentTextView.textColor = [UIColor colorWithHexString:postContentTextColor];
        _postContentTextView.textColor = ETTextColor_First;
        [_postContentTextView jk_addPlaceHolder:@"分享下您的心得与经验......"];
        
        _postContentTextView.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 0);
//        _postContentTextView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
        _postContentTextView.jk_placeHolderTextView.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 0);
    }
    return _postContentTextView;
}

- (UIButton *)pictureButton {
    if (!_pictureButton) {
        _pictureButton = [[UIButton alloc] init];
        [_pictureButton setImage:[UIImage imageNamed:camera] forState:UIControlStateNormal];
//        _pictureButton.backgroundColor = [UIColor redColor];
        @weakify(self)
        [[_pictureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.pickerSubject sendNext:nil];
        }];
    }
    return _pictureButton;
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.image = [UIImage imageNamed:@"pk_report_bg_white"];
    }
    return _bgImage;
}

- (UIButton *)projectButton {
    if (!_projectButton) {
        _projectButton = [[UIButton alloc] init];
//        _projectButton.layer.cornerRadius = ETScreenW * 0.25;
//        _projectButton.clipsToBounds = YES;
        [_projectButton setImage:[UIImage imageNamed:@"plus_red"] forState:UIControlStateNormal];
        @weakify(self)
        [[_projectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.projectSubject sendNext:nil];
        }];
    }
    return _projectButton;
}

- (UITextField *)numberTextField {
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.03];
        _numberTextField.delegate = self;
        _numberTextField.textAlignment = NSTextAlignmentRight;
        _numberTextField.returnKeyType = UIReturnKeyDone;
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextField.hidden = YES;
    }
    return _numberTextField;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.backgroundColor = [ETBlackColor colorWithAlphaComponent:0.03];
    }
    return _unitLabel;
}

- (UIButton *)healthButton {
    if (!_healthButton) {
        _healthButton = [[UIButton alloc] init];
        [_healthButton setTitle:@"获取健康走步数" forState:UIControlStateNormal];
        [_healthButton setTitleColor:ETMinorColor forState:UIControlStateNormal];
        [_healthButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        _healthButton.hidden = YES;
    }
    return _healthButton;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        [_reportButton setTitle:@"提交" forState:UIControlStateNormal];
        [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
        [_reportButton setTitleColor:ETMinorColor forState:UIControlStateNormal];
        [_reportButton setBackgroundColor:ETClearColor];
        _reportButton.layer.cornerRadius = 25;
        [_reportButton.layer setBorderWidth:2];
        [_reportButton.layer setBorderColor:ETMinorColor.CGColor];
        _reportButton.enabled = NO;
    }
    return _reportButton;
}

- (UITableView *)projectTableView {
    if (!_projectTableView) {
        _projectTableView = [[UITableView alloc] init];
        _projectTableView.delegate = self;
        _projectTableView.dataSource = self;
        _projectTableView.backgroundColor = ETClearColor;
        _projectTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_projectTableView registerNib:NibName(ETReportPKTableViewCell) forCellReuseIdentifier:ClassName(ETReportPKTableViewCell)];
    }
    return _projectTableView;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
//        [_mainTableView beginUpdates];
        _mainTableView.tableHeaderView = self.headerView;
//        [_mainTableView endUpdates];
    }
    return _mainTableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.hidden = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETClearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETPhotoCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETPhotoCollectionViewCell)];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UIImageView *)remindPicture {
    if (!_remindPicture) {
        _remindPicture = [[UIImageView alloc] init];
        _remindPicture.hidden = YES;
        [_remindPicture setImage:[UIImage imageNamed:@"remind_pk_report_picture"]];
    }
    return _remindPicture;
}

#pragma mark -- textfield --

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField.text stringByAppendingString:string] integerValue] > 0) {
        [self textFieldEnabled];
    } else {
        [self textFieldDisable];
    }
    return YES;
}

#pragma mark -- textView --

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat textViewHeight =  [self.postContentTextView sizeThatFits:CGSizeMake(self.postContentTextView.frame.size.width, MAXFLOAT)].height;
    CGFloat postViewHeight = textViewHeight > 34 ? (textViewHeight > 51 ? (textViewHeight > 68 ? 101 : 84) : 67) : 50;
    if (self.postView.jk_height != postViewHeight && !self.viewModel.imageIDArray.count) {
        self.postContentTextView.contentOffset = CGPointMake(0, 10);
        [self.mainTableView reloadData];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    self.viewModel.postContent = textView.text;
}

#pragma mark -- UITableViewDelegate And datasouce --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.mainTableView ? 0 : self.viewModel.selectProjectArray.count;
//    return tableView == self.mainTableView ? 2 : self.viewModel.selectProjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        if (indexPath.row == 0) {
            ETSyncPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETSyncPostTableViewCell)];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:ClassName(ETSyncPostTableViewCell) owner:self options:nil].firstObject;
            }
            cell.backgroundColor = ETClearColor;
            cell.viewModel = self.viewModel.syncPostViewModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1) {
            ETShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETShareTableViewCell)];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:ClassName(ETShareTableViewCell) owner:self options:nil].firstObject;
            }
            cell.backgroundColor = ETClearColor;
            cell.viewModel = self.viewModel.shareViewModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else if (tableView == self.projectTableView) {
        ETReportPKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETReportPKTableViewCell) forIndexPath:indexPath];
        ETReportPKTableViewCellViewModel *viewModel = [[ETReportPKTableViewCellViewModel alloc] init];
        viewModel.textFiledSubject = self.viewModel.textFieldSubject;
        viewModel.model = self.viewModel.selectProjectArray[indexPath.row];
        cell.viewModel = viewModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- CollectionViewDelegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.viewModel.imageIDArray.count + 1;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPhotoCollectionViewCell) forIndexPath:indexPath];
    if (indexPath.row != self.viewModel.imageIDArray.count) {
        cell.photo = self.viewModel.selectImgArray[indexPath.row];
    } else {
        cell.photo = [UIImage imageNamed:@"add_photo_gray"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.viewModel.imageIDArray.count) {
        [self.viewModel.pickerSubject sendNext:nil];
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
