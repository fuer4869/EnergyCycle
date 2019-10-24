//
//  ETHomePagePKTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/13.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETHomePagePKTableViewCell.h"

@interface ETHomePagePKTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dashedImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation ETHomePagePKTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETMainBgColor;
    
    self.containerView.backgroundColor = ETProjectRelatedBGColor;
    self.projectNameLabel.textColor = ETTextColor_Second;
    self.leftLabel.textColor = ETTextColor_Second;
    self.rightLabel.textColor = ETTextColor_Third;
    
//    self.containerView.layer.cornerRadius = 10;
//    self.containerView.layer.shadowColor = ETMinorColor.CGColor;
//    self.containerView.layer.shadowOpacity = 0.10;
//    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.picImageView.layer.shadowColor = ETBlackColor.CGColor;
//    self.picImageView.layer.shadowOpacity = 0.10;
//    self.picImageView.layer.shadowOffset = CGSizeMake(0, 0);
    [self drawDashed:self.dashedImageView];
    
    [super updateConstraints];
}

- (void)setPkViewModel:(ETHomePagePKTableViewCellViewModel *)pkViewModel {
    if (!pkViewModel.model) {
        return;
    }
    
    _pkViewModel = pkViewModel;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:pkViewModel.model.FilePath]];
    self.projectNameLabel.text = pkViewModel.model.ProjectName;
    self.leftLabel.text = [NSString stringWithFormat:@"%@%@", pkViewModel.model.ReportNum, pkViewModel.model.ProjectUnit];
    self.rightLabel.text = [NSString stringWithFormat:@"今日排名:%@", pkViewModel.model.Ranking];
}

- (void)setPkRecordViewModel:(ETHomePagePKTableViewCellViewModel *)pkRecordViewModel {
    if (!pkRecordViewModel.model) {
        return;
    }
    
    _pkRecordViewModel = pkRecordViewModel;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:pkRecordViewModel.model.FilePath]];
    self.projectNameLabel.text = pkRecordViewModel.model.ProjectName;
    self.leftLabel.text = [NSString stringWithFormat:@"%@条记录", pkRecordViewModel.model.ReportFre];
    self.rightLabel.text = [pkRecordViewModel.model.CreateTime substringToIndex:10];
    
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
