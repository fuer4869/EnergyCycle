//
//  ETNoticeCommentListTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/6/26.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETNoticeCommentListTableViewCellViewModel.h"

@implementation ETNoticeCommentListTableViewCellViewModel

- (RACSubject *)homePageSubject {
    if (!_homePageSubject) {
        _homePageSubject = [RACSubject subject];
    }
    return _homePageSubject;
}

@end
