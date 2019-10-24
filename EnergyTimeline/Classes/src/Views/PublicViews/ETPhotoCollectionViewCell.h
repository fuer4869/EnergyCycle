//
//  ETPhotoCollectionViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/5/25.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETPhotoCollectionViewCellDelegate <NSObject>

- (void)didLongpressedPhoto:(NSInteger)index;

@end

@interface ETPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *photo;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id<ETPhotoCollectionViewCellDelegate> delegate;

@end
