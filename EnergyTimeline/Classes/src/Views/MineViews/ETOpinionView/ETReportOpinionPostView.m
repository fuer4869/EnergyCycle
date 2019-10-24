//
//  ETReportOpinionPostView.m
//  能量圈
//
//  Created by 王斌 on 2017/12/30.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETReportOpinionPostView.h"
#import "ETReportOpinionPostViewModel.h"

#import "ETPictureCollectionViewCell.h"

#import "UIColor+GradientColors.h"

@interface ETReportOpinionPostView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, ETPictureCollectionViewCellDelegate>

@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) UICollectionView *pictureCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *pictureLayout;

@property (nonatomic, strong) UIButton *reportButton;

//@property (nonatomic, strong) UIImageView *remindPool;

@property (nonatomic, strong) ETReportOpinionPostViewModel *viewModel;

@end

@implementation ETReportOpinionPostView

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETReportOpinionPostViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.pictureCollectionView.mas_top);
    }];
    
    CGFloat collectionViewHeight = (30 + ((ETScreenW - 30) / 5) * (self.viewModel.imageIDArray.count + 1)) > ETScreenW ? ((ETScreenW - 30) / 5) * 2 + 15 : ((ETScreenW - 30) / 5) + 10;
    
    [self.pictureCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
//        make.bottom.equalTo(weakSelf.reportButton.mas_top).with.offset(-35);
        make.bottom.equalTo(weakSelf).with.offset(-85);
        make.height.equalTo(@(collectionViewHeight));
    }];
    
//    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf).with.offset(30);
//        make.right.equalTo(weakSelf).with.offset(-30);
//        make.bottom.equalTo(weakSelf).with.offset(IsiPhoneX ? -(30.f + 34.f) : -30.f);
//        make.height.equalTo(@50);
//    }];
    
    [super updateConstraints];
}

- (void)et_setupViews {
    [self addSubview:self.contentTextView];
    [self addSubview:self.pictureCollectionView];
//    [self addSubview:self.reportButton];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)et_bindViewModel {
//    [self.viewModel.refreshDataCommand execute:nil];
//    [self.viewModel.refreshImgDataCommand execute:nil];
//    [self.viewModel.firstEnterDataCommand execute:nil];
//
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        self.reportButton.backgroundColor = [UIColor colorWithETGradientStyle:ETGradientStyleTopLeftToBottomRight withFrame:self.reportButton.frame andColors:@[[UIColor colorWithHexString:@"FF5C90"], [UIColor colorWithHexString:@"FF8C6E"]]];
        self.contentTextView.text = self.viewModel.postContent;
        self.contentTextView.jk_placeHolderTextView.hidden = ![self.viewModel.postContent isEqualToString:@""];

        [self.pictureCollectionView reloadData];

        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }];

    [self.viewModel.removePictureSubject subscribeNext:^(NSString *imageID) {
        @strongify(self)
        if (imageID) {
            NSInteger index = [self.viewModel.imageIDArray indexOfObject:imageID];
            if (index != NSNotFound) {
                [self.viewModel.imageIDArray removeObjectAtIndex:index];
                [self.viewModel.selectImgArray removeObjectAtIndex:index];
            }
            [self.viewModel.refreshEndSubject sendNext:nil];
        }
    }];

    [[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.reportCommand execute:nil];
    }];
    
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.delegate = self;
        _contentTextView.bounces = NO;
        _contentTextView.backgroundColor = ETMinorBgColor;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        _contentTextView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        //        _contentTextView.textColor = [UIColor colorWithHexString:@"010936"];
        _contentTextView.textColor = ETTextColor_Second;
//        [_contentTextView jk_addPlaceHolder:@"这一刻我想说......"];
        _contentTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _contentTextView.jk_placeHolderTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        [_contentTextView becomeFirstResponder];
        
    }
    return _contentTextView;
}

- (UICollectionView *)pictureCollectionView {
    if (!_pictureCollectionView) {
        _pictureCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.pictureLayout];
        _pictureCollectionView.delegate = self;
        _pictureCollectionView.dataSource = self;
        _pictureCollectionView.backgroundColor = ETClearColor;
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
    }
    return _reportButton;
}

#pragma mark -- TextView --

- (void)textViewDidChange:(UITextView *)textView {
    self.viewModel.postContent = textView.text;
}

#pragma mark -- CollectionViewDelegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.selectImgArray.count == 9 ? 9 : self.viewModel.selectImgArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(((ETScreenW - 30) / 5), ((ETScreenW - 30) / 5));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.pictureCollectionView) {
        if (indexPath.row == self.viewModel.selectImgArray.count && self.viewModel.selectImgArray.count < 9) {
            [self.viewModel.pickerSubject sendNext:nil];
        }
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
