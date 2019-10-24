//
//  ETPromisePostListCollectionViewCell.h
//  能量圈
//
//  Created by 王斌 on 2017/5/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETPromisePostListCollectionCellViewModel.h"

@interface ETPromisePostListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic, strong) ETPromisePostListCollectionCellViewModel *viewModel;

@end
