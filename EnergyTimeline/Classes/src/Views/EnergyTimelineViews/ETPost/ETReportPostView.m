//
//  ETReportPostView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPostView.h"
#import "ETReportPostViewModel.h"
#import "ETPhotoCollectionViewCell.h"
#import "ETShareTableViewCell.h"

#import "ETPostTagView.h"

#import "ETPopView.h"
#import "ETRewardView.h"

#import "ShareSDKManager.h"

@interface ETReportPostView () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ETPopViewDelegate, ECPAlertWhoCellDelegate, ETPhotoCollectionViewCellDelegate> {
    BOOL onTimeline;
    BOOL onWechat;
    BOOL onWeibo;
    BOOL onQQ;
    BOOL onQzone;
}

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) ETReportPostViewModel *viewModel;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *headerContentView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) ETPostTagView *tagView;

@property (nonatomic, strong) UIImageView *tagImageView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UIImageView *remindPicture;

@end

@implementation ETReportPostView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETReportPostViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.headerView).with.offset(10);
        make.right.bottom.equalTo(weakSelf.headerView).with.offset(-10);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerContentView).with.offset(22);
        make.right.equalTo(weakSelf.headerContentView).with.offset(-22);
        make.top.equalTo(weakSelf.headerContentView).with.offset(14);
        make.bottom.equalTo(weakSelf.tagView.mas_top);
    }];
    
//    CGFloat tagHeight = [User_Role integerValue] < 3 ? 20 : 0;
    CGFloat tagHeight = 20;
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerContentView).with.offset(20);
        make.right.equalTo(weakSelf.headerContentView).with.offset(20);
        make.bottom.equalTo(weakSelf.collectionView.mas_top);
        make.height.equalTo(@(tagHeight));
    }];

//    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.equalTo(weakSelf.tagView);
//        make.width.equalTo(@(tagHeight));
//    }];
    
    CGFloat cellWidth = (ETScreenW - 60) / 5 - 10;
    CGFloat collectionViewHeight = (20 + 20 + (cellWidth + 10) * (self.viewModel.imageIDArray.count + 1)) > ETScreenW ? (cellWidth + 20) * 2 : cellWidth + 20;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerContentView).with.offset(10);
        make.right.equalTo(weakSelf.headerContentView).with.offset(-10);
        make.bottom.equalTo(weakSelf.alertWhoView.mas_top).with.offset(-10);
        make.height.equalTo(@(collectionViewHeight));
    }];
    
    [self.remindPicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.collectionView).with.offset(cellWidth + 20);
        make.centerY.equalTo(weakSelf.collectionView);
    }];
    
    [self.alertWhoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerContentView);
        make.right.equalTo(weakSelf.headerContentView);
        make.bottom.equalTo(weakSelf.headerContentView);
        make.height.equalTo(@60);
    }];
    
    [super updateConstraints];
}

#pragma mark -- private --

- (void)et_setupViews {
    [self addSubview:self.mainTableView];
    
    [self.headerView addSubview:self.headerContentView];
    [self.headerContentView addSubview:self.textView];
    [self.headerContentView addSubview:self.tagView];
    [self.headerContentView addSubview:self.collectionView];
    [self.headerContentView addSubview:self.remindPicture];
    [self.headerContentView addSubview:self.alertWhoView];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.firstEnterDataCommand execute:nil];

    RAC(self.viewModel, postContent) = self.textView.rac_textSignal;
    self.viewModel.postType = 1;
    
    @weakify(self)
    [[self.viewModel.reloadSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self.mainTableView reloadData];
    }];
    
    [[self.viewModel.loadDraftSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSArray *drafts = [DraftsModel findAll];
        DraftsModel *model = [drafts lastObject];
        if (drafts.count && model.isNew) {
            model.isNew = NO;
            [model saveOrUpdate];
            self.viewModel.lastDraftModel = model;
            [ETPopView popViewWithDelegate:self Title:@"提示" Tip:@"是否加载最近一次草稿箱的内容" SureBtnTitle:@"好的"];
        }
    }];
    
    [self.viewModel.firstEnterEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (![self.viewModel.firstEnterModel.Is_First_Post_Pic boolValue]) {
            self.remindPicture.hidden = NO;
        }
    }];
    
    if (!self.viewModel.draftModel) {
        [self.viewModel.loadDraftSubject sendNext:nil];
    } else {
        [self loadDraftModel];
    }
    
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
    
    [[self.viewModel.shareSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id responseObject) {
        @strongify(self)
        ETShareModel *shareModel = [[ETShareModel alloc] init];
//        shareModel.title = self.viewModel.projectModel.ProjectName;
        shareModel.title = self.viewModel.postContent;
//        shareModel.content = @"内容";
        
        NSArray *arr = [responseObject[@"Data"] componentsSeparatedByString:@","];
        
        shareModel.shareUrl = [NSString stringWithFormat:@"%@%@?PostID=%@", INTERFACE_URL, HTML_PostDetail, arr[0]];

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
            [ETRewardView rewardViewWithContent:[NSString stringWithFormat:@"+%@积分", arr[1]] duration:2.0 audioType:ETAudioTypeReportPost];
        }
    }];
    
    [[self.viewModel.reloadCollectionViewSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.imageIDArray.count) {
            self.remindPicture.hidden = YES;
        }
        [self.mainTableView reloadData];
        [self.collectionView reloadData];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }];
    
}

- (void)popViewClickSureBtn {
    [MobClick event:@"UsePostDraft"];
    self.viewModel.draftModel = self.viewModel.lastDraftModel;
    [self loadDraftModel];
}

- (void)loadDraftModel {
    if (self.viewModel.draftModel.context.length) {
        self.viewModel.postContent = self.viewModel.draftModel.context;
        self.textView.text = self.viewModel.draftModel.context;
        self.textView.jk_placeHolderTextView.hidden = YES;
    }
    //    self.textView.text
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *newFielPath = [documentsPath stringByAppendingPathComponent:self.viewModel.draftModel.imgLocalURL];
    NSArray *content = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@.plist",newFielPath]];
    for (NSString *imgPath in content) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgPath];
        [self.viewModel.selectImgArray addObject:image];
        [self.viewModel.imageIDArray addObject:imgPath];
    }
    [self.viewModel.reloadCollectionViewSubject sendNext:nil];
}

#pragma mark -- lazyLoad --

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = ETClearColor;
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mainTableView.tableHeaderView = self.headerView;
    }
    return _mainTableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = ETClearColor;
        _headerView.frame = CGRectMake(0, 0, ETScreenW, ETScreenH - kNavHeight - 60);
    }
    return _headerView;
}

- (UIView *)headerContentView {
    if (!_headerContentView) {
        _headerContentView = [[UIView alloc] init];
        _headerContentView.backgroundColor = ETMainBgColor;
        _headerContentView.layer.cornerRadius = 10;
//        _headerContentView.layer.shadowColor = ETMinorColor.CGColor;
//        _headerContentView.layer.shadowOpacity = 0.10;
//        _headerContentView.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return _headerContentView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.backgroundColor = ETMainBgColor;
        _textView.textColor = ETTextColor_First;
        [_textView jk_addPlaceHolder:@"谈谈此刻的想法吧"];
    }
    return _textView;
}

- (ETPostTagView *)tagView {
    if (!_tagView) {
        _tagView = [[ETPostTagView alloc] initWithViewModel:self.viewModel];
    }
    return _tagView;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        [_tagImageView setImage:[UIImage imageNamed:@"tag_yellow"]];
    }
    return _tagImageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
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
        [_remindPicture setImage:[UIImage imageNamed:@"remind_post_report_picture"]];
    }
    return _remindPicture;
}

- (ECPAlertWhoView *)alertWhoView {
    if (!_alertWhoView) {
        _alertWhoView = [[ECPAlertWhoView alloc] init];
        _alertWhoView.text.text = @"@提醒谁看";
        _alertWhoView.text.textColor = ETTextColor_Second;
        _alertWhoView.delegate = self;
        _alertWhoView.layer.cornerRadius = 10;
        _alertWhoView.backgroundColor = ETMainBgColor;
    }
    return _alertWhoView;
}

#pragma mark -- photoCellDelegate --
/** 长按删除图片 */
- (void)didLongpressedPhoto:(NSInteger)index {
    if (self.viewModel.imageIDArray.count) {
        [self.viewModel.removePictureSubject sendNext:[NSNumber numberWithInteger:index]];
    }
}

#pragma mark -- ECPAlertWhoCellDelegate --

- (void)didSelected {
    [self.viewModel.contactVCSubject sendNext:nil];
}

#pragma mark -- textView --


#pragma mark -- delegate and datasouce --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ETShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ClassName(ETShareTableViewCell)];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:ClassName(ETShareTableViewCell) owner:self options:nil].firstObject;
    }
    cell.backgroundColor = ETClearColor;
    cell.viewModel = self.viewModel.shareViewModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- collectionViewDelegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.imageIDArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPhotoCollectionViewCell) forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    if (indexPath.row != self.viewModel.imageIDArray.count) {
        cell.photo = self.viewModel.selectImgArray[indexPath.row];
    } else {
        cell.photo = [UIImage imageNamed:@"add_photo_gray"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ETScreenW - 60) / 5 - 10, (ETScreenW - 60) / 5 - 10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.viewModel.imageIDArray.count) {
        [self.viewModel.pickerSubjet sendNext:nil];
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
