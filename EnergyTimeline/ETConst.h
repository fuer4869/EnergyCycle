//
//  ETConst.h
//  EnergyTimeline
//
//  Created by vj on 2016/11/10.
//  Copyright © 2016年 Weijie Zhu. All rights reserved.
//


/** RGB颜色 */
#define Color_RGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]


/** 根视图窗口 */
#define ETWindow    [UIApplication sharedApplication].keyWindow
/** 屏幕 */
#define ETScreen    [UIScreen mainScreen]
/** 屏幕Bounds */
#define ETScreenB   [UIScreen mainScreen].bounds
/** 屏幕宽度 */
#define ETScreenW   [UIScreen mainScreen].bounds.size.width
/** 屏幕高度 */
#define ETScreenH   [UIScreen mainScreen].bounds.size.height

/** 屏幕Frame宽度 */
/** 屏幕Frame高度 */

/** 输出显示Rect */
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
/** 输出显示Size */
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
/** 输出显示Point */
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

/** 白色返回图片 */
#define ETWhiteBack @"back_white"
/** 灰色返回图片 */
#define ETGrayBack @"back_gray"


