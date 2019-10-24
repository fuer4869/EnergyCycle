//
//  ETProjectCollectionViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/8/3.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETPKProjectModel.h"

typedef enum : NSUInteger {
    ETProjectStateNone = 1,
    ETProjectStateSelect
} ETProjectState;

@interface ETProjectCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ETPKProjectModel *model;

@property (nonatomic, assign) ETProjectState state;

@end
