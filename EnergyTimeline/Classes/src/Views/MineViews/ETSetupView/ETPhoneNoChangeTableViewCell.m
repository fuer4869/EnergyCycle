//
//  ETPhoneNoChangeTableViewCell.m
//  能量圈
//
//  Created by 王斌 on 2017/6/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPhoneNoChangeTableViewCell.h"

static NSString * const phoneNumber_red = @"phoneNumber_red";
static NSString * const verificationCode_red = @"verificationCode_red";

@interface ETPhoneNoChangeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIView *partView;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@end


@implementation ETPhoneNoChangeTableViewCell

- (void)updateConstraints {
    self.backgroundColor = ETClearColor;
    self.textField.textColor = ETTextColor_Second;
//    [self.textField.jk_placeholder

    RAC(self.codeButton, enabled) = self.viewModel.validVerificationCodeSignal;

    if (self.indexPath.section) {
        RAC(self.viewModel, verificationCode) = self.textField.rac_textSignal;
    } else {
        RAC(self.viewModel, phoneNumber) = self.textField.rac_textSignal;
    }
    
    [super updateConstraints];
}

- (void)setViewModel:(ETPhoneNoChangeViewModel *)viewModel {
    if (!viewModel) {
        return;
    }
    
    _viewModel = viewModel;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    
    _indexPath = indexPath;
    
    CGFloat cornerRadius = 10.f;
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(self.bounds, 10, 0);
    if (indexPath.section) {
        [self.leftImageView setImage:[UIImage imageNamed:verificationCode_red]];
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName : ETTextColor_Third}];
        self.textField.attributedPlaceholder = placeholder;
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        [self.leftImageView setImage:[UIImage imageNamed:phoneNumber_red]];
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName : ETTextColor_Third}];
        self.textField.attributedPlaceholder = placeholder;
        self.partView.hidden = YES;
        self.codeButton.hidden = YES;
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
    }
    
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = ETMinorBgColor.CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    self.backgroundView = roundView;
    
}

- (IBAction)codeButton:(id)sender {
    [self.codeButton jk_startTime:1 title:@"重新获取" waitTittle:@"秒"];
    [self.viewModel.verigicationCodeCommand execute:nil];
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
