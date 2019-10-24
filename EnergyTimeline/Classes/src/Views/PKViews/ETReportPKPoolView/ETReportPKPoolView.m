//
//  ETReportPKPoolView.m
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportPKPoolView.h"
#import "ETReportPKPoolViewModel.h"

#import "ETReportPKPoolProjectCollectionViewCell.h"
#import "ETPictureCollectionViewCell.h"

#import "UIColor+GradientColors.h"

@interface ETReportPKPoolView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, ETPictureCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *projectCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *projectLayout;

@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) UICollectionView *pictureCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *pictureLayout;

@property (nonatomic, strong) UIButton *reportButton;

@property (nonatomic, strong) UIImageView *remindPool;

@property (nonatomic, strong) ETReportPKPoolViewModel *viewModel;

@end

@implementation ETReportPKPoolView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETReportPKPoolViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.projectCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.equalTo(@140);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.projectCollectionView.mas_bottom);
        make.bottom.equalTo(weakSelf.pictureCollectionView.mas_top);
    }];
    
    CGFloat collectionViewHeight = (30 + ((ETScreenW - 30) / 5) * (self.viewModel.imageIDArray.count + 1)) > ETScreenW ? ((ETScreenW - 30) / 5) * 2 + 15 : ((ETScreenW - 30) / 5) + 10;
    
    [self.pictureCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.reportButton.mas_top).with.offset(-35);
        make.height.equalTo(@(collectionViewHeight));
    }];
    
    [self.remindPool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.bottom.equalTo(weakSelf.pictureCollectionView.mas_top);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(30);
        make.right.equalTo(weakSelf).with.offset(-30);
        make.bottom.equalTo(weakSelf).with.offset(IsiPhoneX ? -(30.f + 34.f) : -30.f);
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

- (void)et_setupViews {
    [self addSubview:self.projectCollectionView];
    [self addSubview:self.contentTextView];
    [self addSubview:self.remindPool];
    [self addSubview:self.pictureCollectionView];
    [self addSubview:self.reportButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    [self.viewModel.refreshImgDataCommand execute:nil];
    [self.viewModel.firstEnterDataCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.reportButton.backgroundColor = [UIColor colorWithETGradientStyle:ETGradientStyleTopLeftToBottomRight withFrame:self.reportButton.frame andColors:@[[UIColor colorWithHexString:@"FF5C90"], [UIColor colorWithHexString:@"FF8C6E"]]];
        self.contentTextView.text = self.viewModel.postContent;
        self.contentTextView.jk_placeHolderTextView.hidden = ![self.viewModel.postContent isEqualToString:@""];
        
        [self.projectCollectionView reloadData];
        [self.pictureCollectionView reloadData];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }];
    
    [self.viewModel.refreshImageDataEndSubject subscribeNext:^(id x) {
        @strongify(self)
        __block NSInteger convertCount = 0;
        NSMutableArray *cacheArray = [NSMutableArray arrayWithCapacity:self.viewModel.selectImgPathArray.count];
        for (NSInteger i = 0; i < self.viewModel.todayImageIDArray.count; i ++) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.viewModel.selectImgPathArray[i]] options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    convertCount ++;
//                    [self.viewModel.selectImgArray setObject:image atIndexedSubscript:i];
//                    [self.viewModel.todaySelectImgArray setObject:image atIndexedSubscript:i];
                    [cacheArray setObject:image atIndexedSubscript:i];
                    if (convertCount == self.viewModel.todayImageIDArray.count) {
                        [self.viewModel.selectImgArray setArray:cacheArray];
                        [self.viewModel.todaySelectImgArray setArray:cacheArray];
                        [self.viewModel.refreshEndSubject sendNext:nil];
                    }
                }
            }];
        }
    }];
    
    [self.viewModel.removePictureSubject subscribeNext:^(NSString *imageID) {
        @strongify(self)
        if (imageID) {
            NSInteger todayIndex = [self.viewModel.todayImageIDArray indexOfObject:imageID];
            if (todayIndex != NSNotFound) {
                [self.viewModel.todayImageIDArray removeObjectAtIndex:todayIndex];
                [self.viewModel.todaySelectImgArray removeObjectAtIndex:todayIndex];
            }
            NSInteger index = [self.viewModel.imageIDArray indexOfObject:imageID];
            if (index != NSNotFound) {
                [self.viewModel.imageIDArray removeObjectAtIndex:index];
                [self.viewModel.selectImgArray removeObjectAtIndex:index];
            }
            [self.viewModel.refreshEndSubject sendNext:nil];
        }
    }];
    
    [self.viewModel.firstEnterEndSubject subscribeNext:^(id x) {
        @strongify(self)
        if (![self.viewModel.firstEnterModel.Is_FirstPool_Pic boolValue]) {
            self.remindPool.hidden = NO;
        }
    }];
    
    [[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        // 一键汇总完成按钮点击
        [MobClick event:@"ETReportPKPoolVC_FinishClick"];
        [self.viewModel.reportCommand execute:nil];
    }];
    
    // 过1秒后弹出键盘,否则用户不知道哪里可以编辑
    [NSTimer jk_scheduledTimerWithTimeInterval:1.0 block:^{
        [self.contentTextView becomeFirstResponder];
    } repeats:NO];
}

#pragma mark -- lazyLoad --

- (UICollectionView *)projectCollectionView {
    if (!_projectCollectionView) {
        _projectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.projectLayout];
        _projectCollectionView.delegate = self;
        _projectCollectionView.dataSource = self;
        _projectCollectionView.backgroundColor = ETMainBgColor;
        _projectCollectionView.showsVerticalScrollIndicator = NO;
        _projectCollectionView.showsHorizontalScrollIndicator = NO;
        [_projectCollectionView registerNib:NibName(ETReportPKPoolProjectCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETReportPKPoolProjectCollectionViewCell)];
    }
    return _projectCollectionView;
}

- (UICollectionViewFlowLayout *)projectLayout {
    if (!_projectLayout) {
        _projectLayout = [[UICollectionViewFlowLayout alloc] init];
        _projectLayout.minimumLineSpacing = 10;
        _projectLayout.minimumInteritemSpacing = 10;
        _projectLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _projectLayout;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.delegate = self;
        _contentTextView.bounces = NO;
        _contentTextView.backgroundColor = ETProjectRelatedBGColor;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        _contentTextView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
//        _contentTextView.textColor = [UIColor colorWithHexString:@"010936"];
        _contentTextView.textColor = ETTextColor_Second;
        [_contentTextView jk_addPlaceHolder:@"分享下您的心得与经验......"];
        _contentTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _contentTextView.jk_placeHolderTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);

    }
    return _contentTextView;
}

- (UICollectionView *)pictureCollectionView {
    if (!_pictureCollectionView) {
        _pictureCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.pictureLayout];
        _pictureCollectionView.delegate = self;
        _pictureCollectionView.dataSource = self;
        _pictureCollectionView.backgroundColor = ETProjectRelatedBGColor;
        _pictureCollectionView.showsVerticalScrollIndicator = NO;
        _pictureCollectionView.showsHorizontalScrollIndicator = NO;
        [_pictureCollectionView registerNib:NibName(ETPictureCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETPictureCollectionViewCell)];
    }
    return _pictureCollectionView;
}

- (UICollectionViewFlowLayout *)pictureLayout {
    if (!_pictureLayout) {
        _pictureLayout = [[UICollectionViewFlowLayout alloc] init];
        _pictureLayout.minimumLineSpacing = 5;
        _pictureLayout.minimumInteritemSpacing = 5;
        _pictureLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _pictureLayout;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        [_reportButton setTitle:@"完成" forState:UIControlStateNormal];
        [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold]];
        [_reportButton setTitleColor:ETWhiteColor forState:UIControlStateNormal];
        [_reportButton setBackgroundColor:ETMinorColor];
        _reportButton.layer.cornerRadius = 25;
//        [_reportButton.layer setBorderWidth:2];
//        [_reportButton.layer setBorderColor:ETMinorColor.CGColor];
//        _reportButton.enabled = NO;
    }
    return _reportButton;
}

- (UIImageView *)remindPool {
    if (!_remindPool) {
        _remindPool = [[UIImageView alloc] init];
        _remindPool.hidden = YES;
        [_remindPool setImage:[UIImage imageNamed:@"remind_pk_pool"]];
    }
    return _remindPool;
}

#pragma mark -- TextView --

- (void)textViewDidChange:(UITextView *)textView {
    self.viewModel.postContent = textView.text;
}

#pragma mark -- CollectionViewDelegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.viewModel.imageIDArray.count + 1;
    return collectionView == self.projectCollectionView ? self.viewModel.pkDataArray.count : (self.viewModel.selectImgArray.count == 9 ? 9 : self.viewModel.selectImgArray.count + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    ETPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPhotoCollectionViewCell) forIndexPath:indexPath];
//    if (indexPath.row != self.viewModel.imageIDArray.count) {
//        cell.photo = self.viewModel.selectImgArray[indexPath.row];
//    } else {
//        cell.photo = [UIImage imageNamed:@"add_photo_gray"];
//    }
//    return cell;
    if (collectionView == self.projectCollectionView) {
        ETReportPKPoolProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETReportPKPoolProjectCollectionViewCell) forIndexPath:indexPath];
        cell.model = self.viewModel.pkDataArray[indexPath.row];
        return cell;
    } else {
        ETPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPictureCollectionViewCell) forIndexPath:indexPath];
        
        if (self.viewModel.selectImgArray.count < 9 && indexPath.row == self.viewModel.selectImgArray.count) {
            cell.picture = [UIImage imageNamed:@"camera_gray"];
            cell.camera = YES;
        } else {
            cell.picture = self.viewModel.selectImgArray[indexPath.row];
            cell.imageID = self.viewModel.imageIDArray[indexPath.row];
            cell.removeSubject = self.viewModel.removePictureSubject;
            cell.delegate = self;
            cell.camera = NO;
        }
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView == self.projectCollectionView ? CGSizeMake(90, 120) : CGSizeMake(((ETScreenW - 30) / 5), ((ETScreenW - 30) / 5));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return collectionView == self.projectCollectionView ? UIEdgeInsetsMake(10, 10, 10, 10) : UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.pictureCollectionView) {
        if (indexPath.row == self.viewModel.selectImgArray.count && self.viewModel.selectImgArray.count < 9) {
            [self.viewModel.pickerSubject sendNext:nil];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView == self.pictureCollectionView;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (collectionView == self.pictureCollectionView) {
//        if (self.viewModel.selectImgArray.count == 9) {
//            id obj = [self.viewModel.selectImgArray objectAtIndex:sourceIndexPath.row];
//            [self.viewModel.selectImgArray removeObject:obj];
//            [self.viewModel.selectImgArray insertObject:obj atIndex:destinationIndexPath.row];
//        } else {
//
//            id obj = [self.viewModel.selectImgArray objectAtIndex:sourceIndexPath.row];
//            [self.viewModel.selectImgArray removeObject:obj];
//            [self.viewModel.selectImgArray insertObject:obj atIndex:destinationIndexPath.row];
//            NSIndexPath *updateIndexPath = [NSIndexPath indexPathForRow:destinationIndexPath.row  inSection:destinationIndexPath.section];;
//
//        }
        if (self.viewModel.selectImgArray.count < 9 && destinationIndexPath.row == self.viewModel.selectImgArray.count) {
            [self.pictureCollectionView moveItemAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
        } else {
            id obj = [self.viewModel.selectImgArray objectAtIndex:sourceIndexPath.row];
            [self.viewModel.selectImgArray removeObject:obj];
            [self.viewModel.selectImgArray insertObject:obj atIndex:destinationIndexPath.row];
            id obj_id = [self.viewModel.imageIDArray objectAtIndex:sourceIndexPath.row];
            [self.viewModel.imageIDArray removeObject:obj_id];
            [self.viewModel.imageIDArray insertObject:obj_id atIndex:destinationIndexPath.row];
        }
//        [self.pictureCollectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

#pragma mark -- delegate --

- (void)GesturePressDelegate:(UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.pictureCollectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.pictureCollectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.pictureCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.pictureCollectionView updateInteractiveMovementTargetPosition:[gestureRecognizer locationInView:self.pictureCollectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.pictureCollectionView endInteractiveMovement];
            break;
        default:
            [self.pictureCollectionView cancelInteractiveMovement];
            break;
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
