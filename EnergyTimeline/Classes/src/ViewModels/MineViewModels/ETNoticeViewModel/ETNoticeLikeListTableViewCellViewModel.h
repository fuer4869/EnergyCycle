//
//  ETNoticeLikeListTableViewCellViewModel.h
//  能量圈
//
//  Created by 王斌 on 2017/6/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETViewModel.h"
#import "NoticeCommentModel.h"

@interface ETNoticeLikeListTableViewCellViewModel : ETViewModel

@property (nonatomic, strong) NoticeCommentModel *model;

@property (nonatomic, strong) RACSubject *homePageSubject;

@end
