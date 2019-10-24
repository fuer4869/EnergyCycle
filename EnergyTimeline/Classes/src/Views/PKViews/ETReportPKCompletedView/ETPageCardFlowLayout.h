//
//  ETPageCardFlowLayout.h
//  能量圈
//
//  Created by 王斌 on 2017/10/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETPageCardFlowLayoutDelegate <NSObject>

- (void)scrollToPageIndex:(NSInteger)index;

@end

@interface ETPageCardFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat previousOffsetX;

@property (nonatomic, weak) id<ETPageCardFlowLayoutDelegate> delegate;

@end
