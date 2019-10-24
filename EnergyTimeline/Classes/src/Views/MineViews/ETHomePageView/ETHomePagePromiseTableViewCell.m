//
//  ETHomePagePromiseTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePagePromiseTableViewCell.h"

#import "NSString+Time.h"


static NSString * const like = @"like_red";
static NSString * const unlike = @"like_gray";

@interface ETHomePagePromiseTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dashedImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeIntervalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger likes;

@end

@implementation ETHomePagePromiseTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
    self.containerView.backgroundColor = ETProjectRelatedBGColor;
    self.contentLabel.textColor = ETTextColor_Second;
    self.timeIntervalLabel.textColor = ETTextColor_Third;
    self.likeCountLabel.textColor = ETTextColor_Third;
    
//    self.containerView.layer.cornerRadius = 10;
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.10;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.picImageView.layer.shadowColor = ETBlackColor.CGColor;
//    self.picImageView.layer.shadowOpacity = 0.10;
//    self.picImageView.layer.shadowOffset = CGSizeMake(0, 0);
//    [self drawDashed:self.dashedImageView];
    
    [super updateConstraints];
}

- (void)setViewModel:(ETPromisePostListTableViewCellViewModel *)viewModel {
    if (!viewModel.model) {
        return;
    }
    _viewModel = viewModel;
    
//    self.timeIntervalLabel.text = [NSDate jk_timeInfoWithDateString:viewModel.model.CreateTime];
    self.timeIntervalLabel.text = [NSString timeInfoWithDateString:viewModel.model.CreateTime];

    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.model.FilePath]];
    self.picImageView.clipsToBounds = YES;
    self.contentLabel.text = viewModel.model.PostContent;
    
    self.isLike = [viewModel.model.Is_Like boolValue];
    self.likes = [viewModel.model.Likes integerValue];
    [self.likeImageView setImage:[UIImage imageNamed:(self.isLike ? like : unlike)]];
    self.commentCountLabel.text = viewModel.model.CommentNum;
    self.likeCountLabel.text = viewModel.model.Likes;
    
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
- (IBAction)like:(id)sender {
    [self.viewModel.postLikeSubject sendNext:self.viewModel.model.PostID];
    self.isLike = !self.isLike;
    self.likes += self.isLike ? 1 : (-1);
    self.likeCountLabel.text = [NSString stringWithFormat:@"%ld", self.likes];
    [self.likeImageView setImage:[UIImage imageNamed:(self.isLike ? like : unlike)]];
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
