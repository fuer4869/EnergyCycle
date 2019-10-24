//
//  ETLogPostListTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/5/11.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETLogPostListTableViewCell.h"
#import "ETPostTagCollectionViewCell.h"

#import "NSString+Time.h"

#import "ETPopView.h"

static NSString * const like = @"like_red";
static NSString * const unlike = @"like_gray";


@interface ETLogPostListTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ETPopViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *labelCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *dashedImageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger likes;

/** colletionView */

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameLabelLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nickNameLabelRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ETLogPostListTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    
    self.profilePictureButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePictureButton.layer.cornerRadius = self.profilePictureButton.jk_height / 2;
//    self.profilePictureButton.layer.borderWidth = 2;
//    self.profilePictureButton.layer.borderColor = [ETWhiteColor colorWithAlphaComponent:0.4].CGColor;
    self.profilePictureButton.layer.masksToBounds = YES;
    
//    self.containerView.layer.cornerRadius = 10;
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.1;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    [self drawDashed:self.dashedImageView];
    
    [super updateConstraints];
}

- (void)setViewModel:(ETLogPostListTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    _viewModel = viewModel;
    
    if ([viewModel.model.PostType integerValue] == 5) {
        self.profilePictureButton.hidden = YES;
        self.timeIntervalLabel.hidden = YES;
        self.nickNameLabelLeft.constant = 15;
        self.nickNameLabelRight.constant = 15;
        self.nickNameLabel.text = viewModel.model.PostTitle;
        self.readLabel.hidden = NO;
        self.readCountLabel.hidden = NO;
    } else {
        self.profilePictureButton.hidden = NO;
        self.timeIntervalLabel.hidden = NO;
        self.nickNameLabelLeft.constant = 83;
        self.nickNameLabelRight.constant = 103;
        [self.profilePictureButton sd_setImageWithURL:[NSURL URLWithString:viewModel.model.ProfilePicture] forState:UIControlStateNormal placeholderImage:ETUserPortrait_PlaceHolderImage];
        
        self.nickNameLabel.text = viewModel.model.NickName;
    }

//    self.timeIntervalLabel.text = [NSDate jk_timeInfoWithDateString:viewModel.model.CreateTime];
    self.timeIntervalLabel.text = [NSString timeInfoWithDateString:viewModel.model.CreateTime];
//    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.FilePath]];
    if (viewModel.model.FilePath.length) {
        [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath] placeholderImage:ETImageLoading_PlaceHolderImage];
    } else {
        self.firstImageView.image = nil;
    }
    
    if ([viewModel.model.TagID integerValue]) {
        self.collectionViewHeight.constant = 20;
        self.labelCollectionView.delegate = self;
        self.labelCollectionView.dataSource = self;
        [self.labelCollectionView registerNib:NibName(ETPostTagCollectionViewCell) forCellWithReuseIdentifier:ClassName(ETPostTagCollectionViewCell)];
    } else {
        self.collectionViewHeight.constant = 0;
    }
    
    self.firstImageView.layer.masksToBounds = YES;
//    self.contentLabel.text = viewModel.model.PostContent;
    self.contentLabel.text = [viewModel.model.PostType integerValue] == 5 ? @"" : viewModel.model.PostContent;
    
    /** 字符解码 */
    self.contentLabel.text = [[self.contentLabel.text stringByRemovingPercentEncoding] jk_stringByStrippingHTML];
//    [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    if ([viewModel.model.UserID isEqualToString:User_ID] || [User_Role integerValue] < 3) {
        self.deleteButton.hidden = NO;
    } else {
        self.deleteButton.hidden = YES;
    }
    
    self.isLike = [viewModel.model.Is_Like boolValue];
    self.likes = [viewModel.model.Likes integerValue];
    [self.likeImageView setImage:[UIImage imageNamed:(self.isLike ? like : unlike)]];
    self.readCountLabel.text = viewModel.model.ReadCount;
    self.commentCountLabel.text = viewModel.model.CommentNum;
    self.likeCountLabel.text = viewModel.model.Likes;
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.profilePictureButton sizeThatFits:size].height;
    totalHeight += [self.firstImageView sizeThatFits:size].height;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += [self.labelCollectionView sizeThatFits:size].height;
    totalHeight += [self.dashedImageView sizeThatFits:size].height;
    totalHeight += [self.commentImageView sizeThatFits:size].height;
    totalHeight += 75;
    return CGSizeMake(size.width, totalHeight);
}

/** 添加虚线__UIImageView */
- (void)drawDashed:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(imageView.frame.size); //参数size为新创建的位图上下文的大小
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare); //设置线段收尾样式

    CGFloat length[] = {2,2}; // 线的宽度，间隔宽度
    CGContextRef line = UIGraphicsGetCurrentContext(); //设置上下文
    CGContextSetStrokeColorWithColor(line, ETGrayColor.CGColor);
    CGContextSetLineWidth(line, 1); //设置线粗细
    CGContextSetLineDash(line, 0, length, 2);//画虚线
    CGContextMoveToPoint(line, 0, 1.0); //开始画线
    CGContextAddLineToPoint(line, imageView.frame.size.width, 1);//画直线
    CGContextStrokePath(line); //指定矩形线

    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark -- Event --

- (IBAction)homePage:(id)sender {
    [self.viewModel.homePageSubject sendNext:self.viewModel.model.UserID];
}

- (IBAction)deletePost:(id)sender {
    [ETPopView popViewWithDelegate:self Title:@"删除帖子" Tip:@"确定要删除帖子么?" SureBtnTitle:@"确定"];
}

- (IBAction)likePost:(id)sender {
    [self.viewModel.postLikeSubject sendNext:self.viewModel.model.PostID];
    self.isLike = !self.isLike;
    self.likes += self.isLike ? 1 : (-1);
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.likes];
    [self.likeImageView setImage:[UIImage imageNamed:(self.isLike ? like : unlike)]];
}

#pragma mark -- ETPopViewDelegate --

- (void)popViewClickSureBtn {
    [self.viewModel.postDeleteSubject sendNext:self.viewModel];
}

#pragma mark -- collectionDelegate --

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETPostTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClassName(ETPostTagCollectionViewCell) forIndexPath:indexPath];
    cell.tagName.text = self.viewModel.model.TagName;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat totalWidth = 20 + 3;
    totalWidth += [self.viewModel.model.TagName jk_widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:20];
    
    return CGSizeMake(totalWidth, 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
