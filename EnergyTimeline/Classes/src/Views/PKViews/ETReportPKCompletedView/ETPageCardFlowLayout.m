//
//  ETPageCardFlowLayout.m
//  能量圈
//
//  Created by 王斌 on 2017/10/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPageCardFlowLayout.h"

@interface ETPageCardFlowLayout ()

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation ETPageCardFlowLayout

- (void)prepareLayout {
    
    [super prepareLayout];
}

//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
////    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
////    return superAttributes;
//    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
//    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
//
//    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
//                                    self.collectionView.contentOffset.y,
//                                    self.collectionView.frame.size.width,
//                                    self.collectionView.frame.size.height);
//    CGFloat offset = CGRectGetMidX(visibleRect);
//
//    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGFloat distance = offset - attribute.center.x;
//        // 越往中心移动，值越小，那么缩放就越小，从而显示就越大
//        // 同样，超过中心后，越往左、右走，缩放就越大，显示就越小
//        CGFloat scaleForDistance = distance / self.itemSize.width;
//        // 0.1可调整，值越大，显示就越大
//        CGFloat scaleForCell = 1 + 0.1 * (1 - fabs(scaleForDistance));
//
//        //只在Y轴方向做缩放
//        attribute.transform3D =  CATransform3DMakeScale(1, scaleForCell, 1);
//        attribute.zIndex = 1;
//
//        //渐变
//        CGFloat scaleForAlpha = 1 - fabsf(scaleForDistance)*0.6;
//        attribute.alpha = scaleForAlpha;
//    }];
//
//    return attributes;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
        self.previousOffsetX += self.itemSize.width + self.minimumLineSpacing;
        self.pageNum = self.previousOffsetX / (self.itemSize.width + self.minimumLineSpacing);
        if ([self.delegate respondsToSelector:@selector(scrollToPageIndex:)]) {
            [self.delegate scrollToPageIndex:self.pageNum];
        }
    } else if (proposedContentOffset.x < self.previousOffsetX - self.itemSize.width / 3.0) {
        self.previousOffsetX -= self.itemSize.width + self.minimumLineSpacing;
        self.pageNum = self.previousOffsetX / (self.itemSize.width + self.minimumLineSpacing);
        if ([self.delegate respondsToSelector:@selector(scrollToPageIndex:)]) {
            [self.delegate scrollToPageIndex:self.pageNum];
        }
    }
    proposedContentOffset.x = self.previousOffsetX;
    
    return proposedContentOffset;
}

@end
