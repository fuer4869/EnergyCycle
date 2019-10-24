//
//  ETPromisePostListTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/10.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETPromisePostListTableViewCellViewModel.h"

@implementation ETPromisePostListTableViewCellViewModel

- (RACSubject *)homePageSubject {
    if (!_homePageSubject) {
        _homePageSubject = [RACSubject subject];
    }
    return _homePageSubject;
}

- (RACSubject *)postLikeSubject {
    if (!_postLikeSubject) {
        _postLikeSubject = [RACSubject subject];
    }
    return _postLikeSubject;
}

@end
