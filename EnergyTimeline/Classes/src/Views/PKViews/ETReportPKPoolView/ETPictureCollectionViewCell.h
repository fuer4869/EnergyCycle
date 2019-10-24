//
//  ETPictureCollectionViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ETPictureCollectionViewCellDelegate <NSObject>

- (void)GesturePressDelegate:(UIGestureRecognizer *)gestureRecognizer;

@end

@interface ETPictureCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<ETPictureCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) RACSubject *removeSubject;

@property (nonatomic, assign) BOOL camera;

@property (nonatomic, strong) NSString *imageID;

@property (nonatomic, strong) NSString *picturePath;

@property (nonatomic, strong) UIImage *picture;

@end
