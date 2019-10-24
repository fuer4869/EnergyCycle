//
//  ETBadgeRulesView.m
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETBadgeRulesView.h"
#import "ETBadgeRulesViewModel.h"
#import "ETBadgeRulesCollectionViewCell.h"

@interface ETBadgeRulesView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) ETBadgeRulesViewModel *viewModel;

@property (nonatomic, strong) UIButton *detailBackgroundView;

@property (nonatomic, strong) UIView *detailView;

@end

@implementation ETBadgeRulesView

static NSString * const headerViewIdentifier = @"headerView";
static NSString * const footerViewIdentifier = @"footerView";

- (instancetype)initWithViewModel:(id<ETViewModelProtocol>)viewModel {
    self.viewModel = (ETBadgeRulesViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)et_setupViews {
    [self addSubview:self.collectionView];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    WS(weakSelf)
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [super updateConstraints];
}

- (void)et_bindViewModel {
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self)
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self)
        [self.collectionView reloadData];
    }];
    
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ETBadgeRulesCollectionViewCellViewModel *viewModel) {
        @strongify(self)
        [self createDetailViewWithModel:viewModel];
    }];
}

- (void)createDetailViewWithModel:(ETBadgeRulesCollectionViewCellViewModel *)viewModel {
//    self.detailBackgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.detailBackgroundView.frame = [UIApplication sharedApplication].keyWindow.bounds;
//    self.detailBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
//    self.detailBackgroundView.alpha = 0;
//    [self.detailBackgroundView addTarget:self action:@selector(removeDetailView) forControlEvents:UIControlEventTouchUpInside];

    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, ETScreenH, 260, 320)];
    CGPoint center = self.detailBackgroundView.center;
    center.y = - ETScreenH;
    self.detailView.center = center;
    self.detailView.backgroundColor = [UIColor whiteColor];
    self.detailView.layer.cornerRadius = 10;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 150, 150);
    [imageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    imageView.center = CGPointMake(self.detailView.frame.size.width/2, 120);;
    [self.detailView addSubview:imageView];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, self.detailView.frame.size.width, 10)];
    [lineImageView setImage:[UIImage imageNamed:@"pk_badge_detail_line"]];
    [self.detailView addSubview:lineImageView];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    detailLabel.center = CGPointMake(self.detailView.frame.size.width/2, 240);
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = viewModel.model.BadgeName;
    detailLabel.font = [UIFont systemFontOfSize:18];
    detailLabel.textColor = [UIColor colorWithRed:200/255.0 green:106/255.0 blue:106/255.0 alpha:1];
    [self.detailView addSubview:detailLabel];
    UILabel *getCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 12)];
    getCountLabel.center = CGPointMake(self.detailView.frame.size.width/2, 270);;
    getCountLabel.textAlignment = NSTextAlignmentCenter;
    getCountLabel.text = [NSString stringWithFormat:@"已有%@人获得", viewModel.model.HaveNum];
    getCountLabel.font = [UIFont systemFontOfSize:12];
    getCountLabel.textColor = [UIColor colorWithRed:200/255.0 green:106/255.0 blue:106/255.0 alpha:1];
    [self.detailView addSubview:getCountLabel];
    
    center.y = self.detailBackgroundView.frame.size.height / 2;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            self.detailView.center = center;
                            self.detailBackgroundView.alpha = 1;
                            [imageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];

                        } completion:nil];
    
    [self.detailBackgroundView addSubview:self.detailView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.detailBackgroundView];
}

- (void)removeDetailView {
    CGPoint center = self.detailView.center;
    center.y += ETScreenH;
//    center.y = Screen_Height;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2
                        options:UIViewAnimationOptionLayoutSubviews animations:^{
                            self.detailView.center = center;
                            self.detailBackgroundView.alpha = 0;
                        } completion:^(BOOL finished) {
                            for (UIView *view in self.detailBackgroundView.subviews) {
                                [view removeFromSuperview];
                            }
                            [self.detailBackgroundView removeFromSuperview];
                        }];
}

#pragma mark -- lazyLoad -- 

- (ETBadgeRulesViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ETBadgeRulesViewModel alloc] init];
    }
    return _viewModel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = ETMainBgColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:NibName(ETBadgeRulesCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETBadgeRulesCollectionViewCell)];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(ETScreenW, 50);
        _layout.footerReferenceSize = CGSizeMake(ETScreenW, 50);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UIButton *)detailBackgroundView {
    if (!_detailBackgroundView) {
        _detailBackgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBackgroundView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        _detailBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
        _detailBackgroundView.alpha = 0;
        [_detailBackgroundView addTarget:self action:@selector(removeDetailView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailBackgroundView;
}

#pragma mark -- delegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETBadgeRulesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETBadgeRulesCollectionViewCell) forIndexPath:indexPath];
    cell.viewModel = self.viewModel.dataArray[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        NSString *string = @"我的徽章：已获得 0 枚";
        if (self.viewModel.badgeCount) {
            string = [NSString stringWithFormat:@"我的徽章：已获得 %ld 枚", (long)self.viewModel.badgeCount];
        }
        // 根据文本创建属性字符创
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
        // 利用属性字符串将文本颜色替换
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(5, text.length - 5)];
        CGRect frame = reusableView.bounds;
        frame.origin.x = 12;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:12];
        label.attributedText = text;
        [reusableView addSubview:label];
    } else if (kind == UICollectionElementKindSectionFooter) {
        // 创建collection的footerView
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier forIndexPath:indexPath];
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:reusableView.bounds];
        footerLabel.text = @"*根据您发布每日PK汇报的累积天数，获得相应的徽章";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont systemFontOfSize:12];
        footerLabel.textColor = [UIColor grayColor];
        [reusableView addSubview:footerLabel];
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.jk_width - 50) / 3, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ETBadgeRulesCollectionViewCellViewModel *viewModel = self.viewModel.dataArray[indexPath.row];
//    [self.viewModel.cellClickSubject sendNext:viewModel];
    [self createDetailViewWithModel:viewModel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
