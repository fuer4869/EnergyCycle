//
//  GuidePageVC.h
//  能量圈
//
//  Created by 王斌 on 2017/6/27.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewController.h"

typedef enum : NSUInteger {
    ETGuidePageNormal, // 默认启动页
    ETGuidePageGif // gif启动页
} ETGuidePageType; // 启动页类型

@interface ETGuidePageVC : ETViewController

@property (nonatomic, strong) NSArray *pageArray;

@property (nonatomic, assign) ETGuidePageType guidePageType;

@property (nonatomic, strong) RACSubject *pageSubject;

@property (nonatomic, assign) BOOL showPageControl;

@end
