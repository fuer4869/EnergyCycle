//
//  ETPromisePostListTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/5/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "PostModel.h"

@interface ETPromisePostListTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) PostModel *model;

@property (nonatomic, strong) RACSubject *homePageSubject;

@property (nonatomic, strong) RACSubject *postLikeSubject;

@end
