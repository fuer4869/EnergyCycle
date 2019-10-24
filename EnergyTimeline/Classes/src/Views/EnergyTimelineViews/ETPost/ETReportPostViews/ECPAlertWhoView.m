//
//  ECPAlertWhoCell.m
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/8/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPAlertWhoView.h"
#import "ECContactSelectedCell.h"

@interface ECPAlertWhoView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic, strong) UIImageView *rightImg;

@end

@implementation ECPAlertWhoView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark SET/GET

- (void)setDatas:(NSMutableArray *)datas {
    _datas = datas;
    
    CGFloat width = 0.0f;
    width = datas.count > 5 ? 150 : datas.count * 30;
    CGFloat height = 0.0f;
//    height = MAX((datas.count/3), 1) * 32;
    height = datas.count > 5 ? 62 : 31;
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(5);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.height.equalTo(@(height));
        make.width.equalTo(@(width));
    }];
    [self.collectionView reloadData];

//    [self layoutIfNeeded];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma mark Initialize

- (void)setup {
    
    self.text = [UILabel new];
    self.text.textColor = [UIColor blackColor];
    self.text.font = [UIFont systemFontOfSize:16];
    self.text.text = @"提醒谁看";
    [self addSubview:self.text];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    layout.itemSize = CGSizeMake(30, 30);
//    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    self.collectionView.allowsSelection = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ECContactSelectedCell class] forCellWithReuseIdentifier:@"CommentCellID"];
    [self addSubview:self.collectionView];
        
    self.rightImg = [UIImageView new];
    UIImage *image = [UIImage imageNamed:ETLeftArrow_Gray];
    self.rightImg.image = [image jk_imageRotatedByDegrees:180];
    [self addSubview:self.rightImg];
    
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(20);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.text.mas_right).with.offset(30);
        make.right.equalTo(self.rightImg.mas_left);
        make.centerY.equalTo(self);
        make.height.equalTo(@31);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
}

- (void)click {
    if ([self.delegate respondsToSelector:@selector(didSelected)]) {
        [self.delegate didSelected];
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"CommentCellID";
    ECContactSelectedCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UserModel*model = self.datas[indexPath.row];
    cell.model = model;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.ProfilePicture] placeholderImage:[UIImage imageNamed:ETUserPortrait_Default]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


@end
