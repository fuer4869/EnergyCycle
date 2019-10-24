//
//  ETBadgeView.h
//  能量圈
//
//  Created by 王斌 on 2017/11/28.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETBadgeModel.h"
#import "ETPraiseModel.h"

@interface ETBadgeView : UIView

/** 阴影层 */
@property (nonatomic, strong) UIButton *shadowView;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeButton;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *shareButton;
/** 是否为新获得 */
@property (nonatomic, assign) BOOL isGet;
/** 是否为表彰 */
@property (nonatomic, assign) BOOL isPraise;

+ (ETBadgeView *)badgeViewWithModel:(ETBadgeModel *)model;

+ (ETBadgeView *)badgeViewWithModels:(NSArray *)models;

+ (ETBadgeView *)getBadgeViewWithModel:(ETBadgeModel *)model;

+ (ETBadgeView *)getBadgeViewWithModels:(NSArray *)models;

+ (ETBadgeView *)getPraiseViewWithModel:(ETPraiseModel *)model;

+ (ETBadgeView *)getPraiseViewWithModels:(NSArray *)models;

@end
