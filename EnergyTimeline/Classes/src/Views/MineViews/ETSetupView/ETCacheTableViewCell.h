//
//  ETCacheTableViewCell.h
//  能量圈
//
//  Created by 王斌 on 2018/4/23.
//  Copyright © 2018年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ETCacheTypeTrain = 1,
    ETCacheTypeImage,
} ETCacheType;

@interface ETCacheTableViewCell : UITableViewCell

@property (nonatomic, assign) ETCacheType cacheType;

@end
