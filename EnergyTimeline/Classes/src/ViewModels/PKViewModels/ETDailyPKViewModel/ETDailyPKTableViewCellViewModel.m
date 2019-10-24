//
//  ETDailyPKTableViewCellViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKTableViewCellViewModel.h"

@implementation ETDailyPKTableViewCellViewModel

- (RACSubject *)homePageSubejct {
    if (!_homePageSubejct) {
        _homePageSubejct = [RACSubject subject];
    }
    return _homePageSubejct;
}

- (RACSubject *)likeClickSubject {
    if (!_likeClickSubject) {
        _likeClickSubject = [RACSubject subject];
    }
    return _likeClickSubject;
}

@end
