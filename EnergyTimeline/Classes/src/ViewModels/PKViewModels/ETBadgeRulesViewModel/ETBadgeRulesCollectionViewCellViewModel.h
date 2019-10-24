//
//  ETBadgeRulesCollectionViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/18.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "ETPKBadgeModel.h"

@interface ETBadgeRulesCollectionViewCellViewModel : ETViewModel

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) ETPKBadgeModel *model;

@end