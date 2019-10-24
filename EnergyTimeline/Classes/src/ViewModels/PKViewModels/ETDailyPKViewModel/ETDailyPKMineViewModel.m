//
//  ETDailyPKMineViewModel.m
//  能量圈
//
//  Created by 王斌 on 2017/5/15.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "ETDailyPKMineViewModel.h"

@implementation ETDailyPKMineViewModel

- (RACSubject *)homePageSubject {
    if (!_homePageSubject) {
        _homePageSubject = [RACSubject subject];
    }
    return _homePageSubject;
}

- (RACSubject *)likeClickSubject {
    if (!_likeClickSubject) {
        _likeClickSubject = [RACSubject subject];
    }
    return _likeClickSubject;
}

- (RACSubject *)submitSubject {
    if (!_submitSubject) {
        _submitSubject = [RACSubject subject];
    }
    return _submitSubject;
}

- (RACSubject *)setupSubject {
    if (!_setupSubject) {
        _setupSubject = [RACSubject subject];
    }
    return _setupSubject;
}

@end
