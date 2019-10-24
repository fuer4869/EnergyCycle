//
//  ETPostTagCollectionViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/5/29.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTagModel.h"

@interface ETPostTagCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) PostTagModel *model;

@property (weak, nonatomic) IBOutlet UILabel *tagName;

@end
