//
//  UITableView+SectionCorner.h
//  能量圈
//
//  Created by 王斌 on 2017/6/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (SectionCorner)

- (void)deselectSectionCell:(UITableViewCell *)cell CornerRadius:(CGFloat)cornerRadius forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
