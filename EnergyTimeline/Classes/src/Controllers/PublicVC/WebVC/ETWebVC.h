//
//  ETWebVC.h
//  能量圈
//
//  Created by 王斌 on 2017/6/21.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewController.h"
#import "PostModel.h"

typedef enum : NSUInteger {
    ETWebTypePost = 1,
    ETWebTypeRecommendPost,
    ETWebTypeAgreement,
    ETWebTypeActivities
} ETWebType;

@interface ETWebVC : ETViewController

@property (nonatomic, strong) NSString *url;

@property (nonatomic, assign) ETWebType webType;

@property (nonatomic, strong) PostModel *model;

@property (nonatomic, assign) BOOL share;

@end
