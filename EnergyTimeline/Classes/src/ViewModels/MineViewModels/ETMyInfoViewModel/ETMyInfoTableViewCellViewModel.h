//
//  ETMyInfoTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/16.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "UserModel.h"

@interface ETMyInfoTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UserModel *model;

@end
